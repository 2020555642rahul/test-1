read -p "Enter the directory path to analyze: " directory
if [ ! -d "$directory" ]; then
echo "Directory not found."
exit 1
fi

total_size=0
total_files=0
largest_file=0
smallest_file=0
largest_size=0
smallest_size=0
threshold=0

for file in "$directory"/*; do
if [ -f "$file" ]; then
size=$(stat -c %s "$file")
total_size=$((total_size + size))
total_files=$((total_files + 1))

if [ $size -gt $largest_size ]; then
largest_size=$size
largest_file=$file
fi

if [ $smallest_size -eq 0 ] || [ $size -lt $smallest_size ]; then
smallest_size=$size
smallest_file=$file
fi
fi
done


if [ $total_files -gt 0 ]; then
average=$((total_size / total_files))
else
average=0
fi

read -p "Enter the threshold size " threshold

echo "Summary Report: "
echo "Directory: $directory"
echo "Total files: $total_files"
echo "Total Size: $total_size bytes"
echo "Average Size: $average bytes"
echo "Largest File: $largest_file ($largest_size bytes)"
echo "Smallest File: $smallest_file ($smallest_size bytes)"


if [ ! -z "$threshold" ]; then
echo "Files exceeding size threshold of $threshold bytes:"
for file in "$directory"/*; do
if [ -f "$file" ]; then
size=$(stat -c %s "$file")
if [ $size -gt $threshold ]; then
echo "$file ($size bytes)"
fi
fi
done
fi

