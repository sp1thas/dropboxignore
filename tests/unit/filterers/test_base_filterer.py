from dropboxignore.filterers import BaseFilterer


def test_base_filterer_attributes(tmp_path):
    filterer = BaseFilterer(path=tmp_path)
    assert filterer.path == tmp_path
