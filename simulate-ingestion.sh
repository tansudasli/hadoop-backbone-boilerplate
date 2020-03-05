# -------------------------------  simulation of ingestion -------------------------

echo "***** transfer files for ingestion"

for FILE_SUFFIX in 001 002 003 004 005
do
   gsutil cp ./dataset/xyz_${FILE_SUFFIX}.txt gs://${INGESTION_BUCKET_NAME}/incoming

   sleep 5m

done