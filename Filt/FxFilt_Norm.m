function [output] = FxFilt_Norm(input)
temp = input - min(input);
output = temp/max(temp);