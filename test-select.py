import os, sys
sys.path.insert(0, r"C:\Users\Public\sl-build")
import sololuck_miner as m
print("OS:", os.name)
print("features:", {f: m._has(f) for f in ("AVX512F", "AVX2", "AVX", "SSE42")})
print("cpu_signature:", m.cpu_signature())
print("engine_dir:", m.engine_dir())
print("candidates:", m._engine_candidates())
chosen = m.select_engine()
print("SELECTED:", os.path.basename(chosen) if chosen else None)
