function [ descrip_string ] = netlist_description(curr_comp, comp_num)
% Function to create description string from array of circuit components

% get component type and number (i.e C1, R3)
comp = string(curr_comp.CompName);
if comp == 'Resistor' || comp == 'Capacitor' || comp == 'VoltageSource'
    comp = char(comp);
    compchar = comp(1);
elseif comp == 'Inductor'
    compchar = 'L';
elseif comp == 'CurrentSource'
    compchar = 'I';
end
comp_name = strcat(compchar, string(comp_num));

% get component value
comp_val = '';
for v=1:size(curr_comp.Words.Values,1)
    TF = isstrprop(curr_comp.Words.Values(v), 'digit');
    TF = TF{1};
    if TF(1)
        comp_val = curr_comp.Words.Values(v);
        break
    end
end   

if length(char(curr_comp.Words.Values(v+1))) > 1
    curr_unit = char(curr_comp.Words.Values(v+1));
    curr_unit = curr_unit(1);
    if isstrprop(curr_unit, 'upper')
        curr_unit = lower(curr_unit);
    end
    comp_val = strcat(comp_val, curr_unit);
end

% get nodes
if string(comp) == 'VoltageSource' || string(comp) == 'CurrentSource'
    comp_nodes = char(strcat(num2str(curr_comp.CompNodes(2)-1), {' '}, num2str(curr_comp.CompNodes(1)-1)));
else
    comp_nodes = char(strcat(num2str(curr_comp.CompNodes(1)-1), {' '}, num2str(curr_comp.CompNodes(2)-1)));
end

descrip_string = char(strcat(comp_name, {' '}, comp_nodes, {' '}, comp_val));


