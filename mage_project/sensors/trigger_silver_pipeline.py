if 'sensor' not in globals():
    from mage_ai.data_preparation.decorators import sensor


@sensor
def sensor_function(pipeline_run=None, **kwargs):
    from mage_ai.orchestration.triggers.api import trigger_pipeline

    trigger_pipeline('dbt_build_silver')
    return True