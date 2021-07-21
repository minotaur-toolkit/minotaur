import os
import lit.formats

config.name = 'Minotaur'
config.test_format = lit.formats.MinotaurTest()
config.test_source_root = os.path.dirname(__file__)
