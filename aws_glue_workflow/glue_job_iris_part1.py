import sys

from pyspark.context import SparkContext

from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import Join
from awsglue.utils import getResolvedOptions

glueContext = GlueContext(SparkContext.getOrCreate())

# catalog: database and table names
db_name = "glue-testing-9ejk35cfz"

# output s3 and temp directories
output_dir = "s3://glue-testing-9ejk35cfz-code/output"

# Create dynamic frames from the source tables
iris = glueContext.create_dynamic_frame.from_catalog(
    database="glue-testing-9ejk35cfz", table_name="glue_testing_9ejk35cfz_data"
)

# Keep the fields we need and rename some.
iris = (
    iris.drop_fields(["sepal length _cm_"])
    .rename_field("petal length _cm_", "petal len")
    .rename_field("petal width _cm_", "petal wdth")
)

# Write out the dynamic frame into parquet
print("Writing to output_dir: {} ...".format(output_dir))
glueContext.write_dynamic_frame.from_options(
    frame=iris,
    connection_type="s3",
    connection_options={"path": output_dir},
    format="parquet",
)