from datasets import load_dataset
import json

ds = load_dataset("Maxscha/commitbench")

# 計算前 50% 的數據量
total_samples = len(ds['train'])
half_samples = total_samples // 2  # 取前 50%

# 🚀 確保我們在 `Dataset` 上正確地遍歷，而不是直接切片
json_data = []
for i in range(half_samples):
    entry = ds['train'][i]  # 獲取正確的字典格式

    json_data.append({
        "instruction": "Generate commit message for diff",
        "input": entry.get('diff', ""),  # 確保 `diff` 存在
        "output": entry.get("message", "")  # 確保 `message` 存在
    })


with open("data/commitbench_half.json", "w", encoding="utf-8") as f:
    json.dump(json_data, f, ensure_ascii=False, indent=4)

print(f"save the first 50% training data in data/commitbecnh_hash.json")