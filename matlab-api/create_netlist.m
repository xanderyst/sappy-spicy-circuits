function create_netlist( comps )
%Create .txt file for netlist

fileID = fopen('sappy_netlist.txt', 'w');
fprintf(fileID, 'Sappy Spicy Simulation 1-1 \n');
fprintf(fileID, '\n');
fprintf(fileID, '* CIRCUIT Description * \n');

for x = 1:length(comps)
    descrip = netlist_description(comps(x));
    descrip = strcat(descrip, '\n');
    fprintf(fileID, descrip);
end

fclose(fileID);



