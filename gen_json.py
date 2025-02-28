from datasets import load_dataset
import json

ds = load_dataset("Maxscha/commitbench")

# 計算前 50% 的數據量
total_samples = len(ds['train'])
half_samples = total_samples // 2  # 取前 50%

# 轉換數據格式
json_data = [
    {
        "instruction": "Generate commit message for diff",
        "input": entry['diff'],
        "output": entry["message"]
    }
    for entry in ds['train'][:half_samples]  # 只取前 50%
]
with open("data/commitbench_half.json", "w", encoding="utf-8") as f:
    json.dump(json_data, f, ensure_ascii=False, indent=4)

print(f"save the first 50% training data in {output_path}")