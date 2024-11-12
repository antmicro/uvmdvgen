% for dir in include_dirs:
+incdir+${dir}
% endfor

# SystemVerilog Files
% for file in sv_files:
${file}
% endfor
