import z3

# VPDPBUSD, in VNNI
"""
FOR j := 0 to 15
	tmp1.word := Signed(ZeroExtend16(a.byte[4*j]) * SignExtend16(b.byte[4*j]))
	tmp2.word := Signed(ZeroExtend16(a.byte[4*j+1]) * SignExtend16(b.byte[4*j+1]))
	tmp3.word := Signed(ZeroExtend16(a.byte[4*j+2]) * SignExtend16(b.byte[4*j+2]))
	tmp4.word := Signed(ZeroExtend16(a.byte[4*j+3]) * SignExtend16(b.byte[4*j+3]))
	dst.dword[j] := Saturate32(src.dword[j] + tmp1 + tmp2 + tmp3 + tmp4)
ENDFOR
dst[MAX:512] := 0
"""

# At beginning
#   element0 is 0th byte in register 0
#   element8 is 0th byte in register 1, ...

# At finishing, "required lane analysis"
#   element 0-4 and 16-20 is used in 0th lane of the result, ...

class Solve_VNNItoNonVNNI(object):
    def __init__(self):
        # start with 3 register for input A, B, C
        self.start_with = 3
        self.step = 1
        self.final_reg = self.start_with + self.step
        self.widths = [8, 16, 32, 64]
        self.terops = {'vpdpbusd': {"op0": {"map": lambda a : a // 4,   "shape": (64, 8)   },
                                    "op1": {"map": lambda a : a // 4,   "shape": (64, 8)   },
                                    "op2": {"map": lambda a : a,        "shape": (16, 32)  },
                                    "result": {                         "shape": (16, 32)  }}}

        self.binops = {'vpmaddubsw': {"op0": {"map": lambda a : a // 2, "shape": (64, 8)   },
                                      "op1": {"map": lambda a : a // 2, "shape": (64, 8)   },
                                      "result": {                       "shape": (32, 16)  }},
                       'vpmaddwd':   {"op0": {"map": lambda a : a // 2, "shape": (32, 16)  },
                                      "op1": {"map": lambda a : a // 2, "shape": (32, 16)  },
                                      "result": {                       "shape": (16, 32)  }},
                       'vpadd':      {"op0": {"map": lambda a : a,      "shape": (16, 32)  },
                                      "op1": {"map": lambda a : a,      "shape": (16, 32)  },
                                      "result": {                       "shape": (16, 32)  }}}


    def _ternaryop(self, opcode, regA, regB, regC, regR):
        return z3.Bool(f'{regR}={opcode}_{regA}_{regB}_{regC}') # 

    def _binaryop(self, opcode, regA, regB, regR):
        return z3.Bool(f'{regR}={opcode}_{regA}_{regB}')
    
    def _lane_width(self, reg, width):
        return z3.Bool(f'lanewidth_{reg}_{width}')

    def _precondition(self, s):
        # set input width
        for i in self.widths:
            if i == 8:
                s.add(self._lane_width(0, i))
                s.add(self._lane_width(1, i))
            else:
                s.add(self._lane_width(0, i) == False)
                s.add(self._lane_width(1, i) == False)

            if i == 32:
                s.add(self._lane_width(2, i))
            else:
                s.add(self._lane_width(2, i) == False)

    def _postcondition(self, s):
        for i in self.widths:
            if i == 32:
                s.add(self._lane_width(self.final_reg - 1, i))
            else:
                s.add(self._lane_width(self.final_reg - 1, i) == False)

    def _encode(self, s):
        print ("=== adding preconditions")
        self._precondition(s)
        print ("=== adding postcondition")
        self._postcondition(s)
        print ("=== adding correctness constraints")
        for n in range(self.start_with, self.final_reg):
            ops_exclusive = []

            for binop in self.binops:
                for op0 in range(n):
                    for op1 in range(n):
                        ops_exclusive.append((self._binaryop(binop, op0, op1, n), 1))
                        s.add(z3.Implies(self._binaryop(binop, op0, op1, n), 
                                         z3.And(self._lane_width(op0, self.binops[binop]["op0"]["shape"][1]),
                                                self._lane_width(op1, self.binops[binop]["op1"]["shape"][1]),
                                                self._lane_width(n, self.binops[binop]["result"]["shape"][1]))))

            for terop in self.terops:
                for op0 in range(n):
                    for op1 in range(n):
                        for op2 in range(n):
                            ops_exclusive.append((self._ternaryop(terop, op0, op1, op2, n), 1))  
                            s.add(z3.Implies(self._ternaryop(terop, op0, op1, op2, n), 
                                             z3.And(self._lane_width(op0, self.terops[terop]["op0"]["shape"][1]),
                                                    self._lane_width(op1, self.terops[terop]["op1"]["shape"][1]),
                                                    self._lane_width(op2, self.terops[terop]["op2"]["shape"][1]),
                                                    self._lane_width(n, self.terops[terop]["result"]["shape"][1]))))

            # only one operation per new value
            s.add(z3.PbEq(ops_exclusive, 1))

            width_exclusive = []
            for width in self.widths:
                width_exclusive.append((self._lane_width(n, width),1))
            s.add(z3.PbEq(width_exclusive, 1))

    def solve(self):
        s = z3.Solver()
        self._encode(s)


        # cexps
        #s.add(z3.Bool('3=vpdpbusd_1_0_2') == False)
        #s.add(z3.Bool('3=vpdpbusd_0_1_2') == False)
        #s.add(z3.Bool('3=vpadd_2_2') == False)
        #s.add(z3.Bool('3=vpdpbusd_1_1_2') == False)
        #s.add(z3.Bool('3=vpdpbusd_0_0_2') == False)

        s.add(z3.Bool('3=vpadd_2_2') == False)
        s.add(z3.Bool('3=vpdpbusd_0_0_2') == False)

        print("=== solving")
        if s.check() == z3.sat:
            print(">>> found a solution")
            m = s.model()
            #pretty printer
            for n in range(self.start_with, self.final_reg):
                ops = []
                for terop in self.terops:
                    for op0 in range(n):
                        for op1 in range(n):
                            for op2 in range(n):
                                if (z3.is_true(m.eval(self._ternaryop(terop, op0, op1, op2, n)))):
                                    print(f'%{n} = {terop} %{op0}, %{op1}, %{op2}')
                for binop in self.binops:
                    for op0 in range(n):
                        for op1 in range(n):
                                if (z3.is_true(m.eval(self._binaryop(binop, op0, op1, n)))):
                                    print(f'%{n} = {binop} %{op0}, %{op1}')
        else:
            print(">>> no solution")

A = Solve_VNNItoNonVNNI()
A.solve()

