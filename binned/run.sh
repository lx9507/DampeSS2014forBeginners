#!/bin/bash

. var_common.gts &&

./sc_filter.gts &&
python model.py &&
cp model.xml $file_model_initial &&
./like_binned.gts &&
./residual.gts &&
echo
