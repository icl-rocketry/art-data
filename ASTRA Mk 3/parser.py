import pathlib
import struct
import sys
import os

header = ["Time (ms)", "Pressure", "Temperature"]

if __name__ == "__main__":
    path = sys.argv[1]

    with open(path, "rb") as file:
        all_bytes = file.read()[:-20]
        filtered_bytes = bytearray()

        for i in range(0, len(all_bytes), 4):
            word = all_bytes[i:i+4]
            if any(word):
                for byte in word:
                    filtered_bytes.append(byte)

        records = list(struct.iter_unpack("Iff", filtered_bytes))

    records = [header] + records

    fname, _ = os.path.splitext(path)    
    with open(fname + "_parsed.csv", "w") as file:
        for record in records:
            file.write(", ".join(map(str, record)) + "\n")

