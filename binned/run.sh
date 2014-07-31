#!/bin/bash

./sc_filter.gts &&
python model.py &&
./like_binned.gts &&
./residual.gts &&
echo
