from datasets import load_dataset
import json

ds = load_dataset("Maxscha/commitbench")

json_data = [
    {
        "instruction": f"generate commit message for {entry['diff']}",
        "input": "",
        "output": entry["message"]
    }
    for entry in ds['train']
]

with open("data/commitbench.json", "w", encoding="utf-8") as f:
    json.dump(json_data, f, ensure_ascii=False, indent=4)
