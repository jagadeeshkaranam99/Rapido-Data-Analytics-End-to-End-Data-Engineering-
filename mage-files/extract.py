import io
import pandas as pd
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Extracts raw Rapido trip dataset from cloud/GitHub storage.
    """
    url = 'https://raw.githubusercontent.com/jagadeeshkaranam99/Rapido-Data-Analytics-End-to-End-Data-Engineering-/main/data/rapido_data.xlsx'
    response = requests.get(url)
    response.raise_for_status()

    return pd.read_excel(io.BytesIO(response.content))


@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'
    assert len(output) > 0, 'Extracted dataframe is empty'
