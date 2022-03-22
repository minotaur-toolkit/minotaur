// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Utils.h"

#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Passes/PassBuilder.h"

#include "hiredis.h"

namespace minotaur {

void eliminate_dead_code(llvm::Function &F) {
  llvm::FunctionAnalysisManager FAM;

  llvm::PassBuilder PB;
  PB.registerFunctionAnalyses(FAM);

  llvm::FunctionPassManager FPM;
  FPM.addPass(llvm::DCEPass());
  FPM.run(F, FAM);
}

bool
hGet(const char* s, unsigned sz, std::string &Value, redisContext *c) {
  redisReply *reply = (redisReply *)redisCommand(c, "HGET %b rewrite", s, sz);
  if (!reply || c->err) {
    llvm::report_fatal_error((llvm::StringRef)"redis error" + c->errstr);
  }
  if (reply->type == REDIS_REPLY_NIL) {
    freeReplyObject(reply);
    return false;
  } else if (reply->type == REDIS_REPLY_STRING) {
    Value = reply->str;
    freeReplyObject(reply);
    return true;
  } else {
    llvm::report_fatal_error((llvm::StringRef)
      "Redis protocol error for cache lookup, didn't expect reply type "+
      std::to_string(reply->type));
  }
}

void
hSet(const char* s, unsigned sz, llvm::StringRef Value, redisContext *c, unsigned oldcost, unsigned newcost) {
  redisReply *reply = (redisReply *)redisCommand(c, "HSET %b rewrite %s oldcost %s newcost %s",
    s, sz, Value.data(), std::to_string(oldcost).c_str(), std::to_string(newcost).c_str());
  if (!reply || c->err)
    llvm::report_fatal_error((llvm::StringRef)"Redis error: " + c->errstr);
  if (reply->type != REDIS_REPLY_INTEGER) {
    llvm::report_fatal_error((llvm::StringRef)
      "Redis protocol error for cache fill, didn't expect reply type " +
      std::to_string(reply->type));
  }
  freeReplyObject(reply);
}

}