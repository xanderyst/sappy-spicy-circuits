function create_netlist( comps )
%Create .txt file for netlist

fileID = fopen('sappy_netlist.txt', 'w');
fprintf(fileID, 'Sappy Spicy Simulation 1-1 \n');
fprintf(fileID, '\n');
fprintf(fileID, '* CIRCUIT Description * \n');

Rs = 0; Cs = 0; Ls = 0; Vs = 0; Is = 0;
for x = 1:length(comps)
    comp_num = 0;
    if strcmp(comps(x).CompName,'Resistor')
        Rs = Rs + 1;
        comp_num = Rs;
    elseif strcmp(comps(x).CompName,'Capacitor')
        Cs = Cs + 1;
        comp_num = Cs;
    elseif strcmp(comps(x).CompName,'Inductor')
        Ls = Ls + 1;
        comp_num = Ls;
    elseif strcmp(comps(x).CompName, 'Voltage Source')
        Vs = Vs + 1;
        comp_num = Ls;
    elseif strcmp(comps(x).CompName, 'Current Source')
        Is = Is + 1;
        comp_num = Is;
    end
    descrip = netlist_description(comps(x), comp_num);
    descrip = strcat(descrip, '\n');
    fprintf(fileID, descrip);
end

fclose(fileID);


    
    
    



