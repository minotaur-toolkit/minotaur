import os
import lit.formats

config.name = 'VectorSynth'
config.test_format = lit.formats.VectorSynthTest()
config.test_source_root = os.path.dirname(__file__)
