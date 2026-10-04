"""Small command-surface checks; no native transport or PFR acceptance."""
import tempfile
from pathlib import Path
import unittest
from unittest.mock import patch

import cli


class CommandTests(unittest.TestCase):
    def test_api_exposes_real_signatures_without_transport(self):
        result=cli.entry(Path.cwd(),'api')
        self.assertEqual(set(result['methods']),set(cli.METHODS))
        self.assertIn('question',result['methods']['prepare_review'])
        self.assertNotIn('own_edit',result['methods'])
        self.assertIn('Python never does',result['native_calls'])

    def test_instructions_are_read_from_selected_checkout(self):
        with tempfile.TemporaryDirectory(prefix='pfr-cli-') as folder:
            root=Path(folder); (root/'docs').mkdir()
            expected={}
            for filename in ('review-protocol.md','review-operations.md'):
                rel='docs/'+filename; expected[rel]='Source-copy instructions: '+filename
                (root/rel).write_text(expected[rel],encoding='utf-8')
            self.assertEqual(cli.entry(root,'instructions'),expected)

    def test_generic_call_rejects_unlisted_method(self):
        with patch.object(cli,'load_session',return_value=object()):
            with self.assertRaisesRegex(ValueError,'METHOD_NOT_EXPOSED'):
                cli.entry(Path.cwd(),'call',{'method':'__getattribute__'},chunk='PFR-C02')

    def test_generic_call_rejects_code_shaped_arguments(self):
        with patch.object(cli,'load_session',return_value=object()):
            with self.assertRaisesRegex(ValueError,'CALL_ARGUMENTS'):
                cli.entry(Path.cwd(),'call',{'method':'inspect','args':'not a list'},chunk='PFR-C02')


if __name__=='__main__':unittest.main()
