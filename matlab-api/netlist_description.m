function [ descrip_string ] = netlist_description(curr_comp)
% Function to create description string from array of circuit components

% get component type and number (i.e C1, R3)
compchar = curr_comp.Words.Values(1);
comp_name = (curr_comp.Words.Values(1));
if isstrprop(compchar{1}(1), 'lower')
    comp_name(1) = upper(comp_name(1));
end
comp_name = char(comp_name);

% get component value
comp_val = curr_comp.Words.Values(2);
if length(char(curr_comp.Words.Values(3))) > 1
    curr_unit = char(curr_comp.Words.Values(3));
    curr_unit = curr_unit(1);
    if isstrprop(curr_unit(1), 'upper')
        curr_unit = upper(curr_unit);
    end
    comp_val = char(strcat(comp_val,{' '}, curr_unit));
end

% get nodes
comp_nodes = char(strcat(num2str(curr_comp.CompNodes(1)), {' '}, num2str(curr_comp.CompNodes(2))));

descrip_string = char(strcat(comp_name, {' '}, comp_nodes, {' '}, comp_val));


