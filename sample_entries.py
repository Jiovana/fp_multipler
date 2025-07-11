import csv
import random
import os

# === CONFIGURATION ===
input_files = [
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_alexnet.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_bmjsh.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_cheng.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_deeplab.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_inception.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_ssd.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_unet.csv",
    "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_yolo11s.csv"
]

output_file = "C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/test_vectors/test_vectors_sampled_40k.csv"
total_samples = 40_000
non_weight_ratio = 0.01  # 1%

non_weight_count = int(total_samples * non_weight_ratio)
weight_count = total_samples - non_weight_count

# === FUNCTION TO LOAD AND FILTER CSV FILES ===
def collect_entries(files):
    weight_entries = []
    non_weight_entries = []
    for fname in files:
        with open(fname, newline='') as f:
            reader = csv.reader(f)
            next(reader)  # skip header
            for row in reader:
                if row[1] == '0':
                    non_weight_entries.append(row)
                else:
                    weight_entries.append(row)
    return weight_entries, non_weight_entries

# === LOAD DATA ===
weight_entries, non_weight_entries = collect_entries(input_files)

# === VALIDATION ===
if len(weight_entries) < weight_count:
    raise ValueError(f"Not enough weight entries. Required: {weight_count}, Available: {len(weight_entries)}")

if len(non_weight_entries) < non_weight_count:
    raise ValueError(f"Not enough non-weight entries. Required: {non_weight_count}, Available: {len(non_weight_entries)}")

# === SAMPLE AND SHUFFLE ===
sampled_weights = random.sample(weight_entries, weight_count)
sampled_non_weights = random.sample(non_weight_entries, non_weight_count)

combined = sampled_weights + sampled_non_weights
random.shuffle(combined)

# === SAVE TO FILE ===
os.makedirs(os.path.dirname(output_file), exist_ok=True)

with open(output_file, "w", newline='') as out_csv:
    writer = csv.writer(out_csv)
    writer.writerow(["level", "is_weight", "expected"])
    writer.writerows(combined)

print(f"[INFO] Sampled dataset with 1:100 ratio written to {output_file}")
