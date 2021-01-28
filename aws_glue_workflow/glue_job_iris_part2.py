import sys

from pyspark.context import SparkContext

from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import Join
from awsglue.utils import getResolvedOptions

glueContext = GlueContext(SparkContext.getOrCreate())

# catalog: database and table names
db_name = "glue-testing-dabu5788"

# output s3 and temp directories
output_dir = "s3://glue-testing-dabu5788-code/output"

# Create dynamic frames from the source tables
iris = glueContext.create_dynamic_frame.from_catalog(
    database="glue-testing-dabu5788", table_name="glue_testing_dabu5788_data"
)

# Rename field
iris = (
    iris.rename_field("sepal width _cm_", "sepal wdth")
)

# Write out the dynamic frame into parquet
print("Writing to output_dir: {} ...".format(output_dir))
glueContext.write_dynamic_frame.from_options(
    frame=iris,
    connection_type="s3",
    connection_options={"path": output_dir},
    format="parquet",
)