function property_assigner()

clc ;
clear all ;
close all ;

% start first by setting the default directory 

old_directory = cd('D:\Study\Thesis\FE_abaqus_simulations_28_10\2D_random\rve_size_test') ; % These are the absolute co-ordinates that are given in the assembly



rve_number = 6 ;   % ENTER THE CORRECT NUMBER IN EVERY SIMU

Jobs_per_rve = 8 ;

%Copy all the input files in the workspace.

 for d = 1:rve_number
     for h = 1:Jobs_per_rve     
     cd('D:\Study\Thesis\FE_abaqus_simulations_28_10\2D_random\rve_size_test') ;
       if (d == 1)
        ...
       polyjet_grid_size = 4 ;        % The number of elements in the x by x grid. 
        cd 4
        filename = 'elements.dat' ;
        mesh_elements = csvread(filename) ;
         ...
       end
   
       if (d == 2)
        ...
       polyjet_grid_size = 8 ;        % The number of elements in the x by x grid. 
        cd 8
        filename = 'elements.dat' ;
        mesh_elements = csvread(filename) ;
         ...
       end
   
   
       if (d == 3)
        ...
       polyjet_grid_size = 16 ;        % The number of elements in the x by x grid. 
        cd 16
        filename = 'elements.dat' ;
        mesh_elements = csvread(filename) ;
         ...
       end
   
        if (d == 4)
        ...
        polyjet_grid_size = 24 ;        % The number of elements in the x by x grid. 
        cd 24
        filename = 'elements.dat' ;
        mesh_elements = csvread(filename) ;
         ...
        end
    
        if (d == 5)
        ...
        polyjet_grid_size = 32 ;        % The number of elements in the x by x grid. 
        cd 32
        filename = 'elements.dat' ;
        mesh_elements = csvread(filename) ;
         ...
        end
    
        if (d == 6)
        ...
        polyjet_grid_size = 64 ;        % The number of elements in the x by x grid. 
        cd 64
        filename = 'elements.dat' ;
        mesh_elements = csvread(filename) ;
         ...
        end
   
       if (h == 1)
        ...
        mkdir('1') ;
        cd 1
         ...
       end
   
        if (h == 2)
        ...
        mkdir('2') ;
        cd 2
         ...
        end
   
        if (h == 3)
        ...
        mkdir('3') ;
        cd 3
         ...
        end
    
        if (h == 4)
        ...
        mkdir('4') ;
        cd 4
         ...
        end
    
        if (h == 5)
        ...
        mkdir('5') ;
        cd 5
         ...
        end
   
        if (h == 6)
        ...
        mkdir('6') ;
        cd 6
         ...
        end
    
        if (h == 7)
        ...
        mkdir('7') ;
        cd 7
         ...
        end
    
        if (h == 8)
        ...
        mkdir('8') ;
        cd 8
         ...
        end

mesh_elements_serial = mesh_elements(:,1) ;

f = size(mesh_elements) ;

nodes_per_element = f(1,2) - 1 ;

element_nodes = mesh_elements(:,2:f(1,2))  ;

number_of_mesh_element = length(mesh_elements_serial) ;

polyjet_grid_dimension = polyjet_grid_size * polyjet_grid_size ;

mesh_elements_per_polyjet_grid_element = number_of_mesh_element/polyjet_grid_dimension ;

elements_set = zeros(polyjet_grid_dimension,mesh_elements_per_polyjet_grid_element) ;

count_mesh_element = 0;

for i=1:polyjet_grid_dimension
    for j=1:mesh_elements_per_polyjet_grid_element
       count_mesh_element = count_mesh_element + 1;
       elements_set(i,j) = mesh_elements_serial(count_mesh_element)  ;
    end
end

volume_ratio = 0.5 ;     % Please set the volume ratio accordingly. % do that for volume ratio from 0.1 to 0.9

v1_elements = volume_ratio * polyjet_grid_dimension ;

v1_elements = round(v1_elements) ;

v2_elements = polyjet_grid_dimension - v1_elements ;

not_assigned = 1 ;

element_unused = ones(polyjet_grid_dimension,1) ;

material = zeros(1,polyjet_grid_dimension) ;

mesh_element_material_property_assignment = zeros(number_of_mesh_element,1) ;


for i = 1:1:v1_elements
    not_assigned = 1 ;
    while (not_assigned == 1)
        position_co_ordinate = rand(1,1) ;
        element_to_assign = position_co_ordinate * polyjet_grid_dimension ;
        element_to_assign = floor(element_to_assign) + 1 ;
        
        if (element_unused(element_to_assign,1) == 1)
            material(1,element_to_assign) = 5 ; 
            element_unused(element_to_assign,1) = 0 ;
            not_assigned = 0 ;
            
            temp_a = elements_set(element_to_assign,:);
            
            counter_k = 1 ;
            
            while (counter_k < ( mesh_elements_per_polyjet_grid_element + 1 ) )
            
                 mesh_element_material_property_assignment(temp_a(counter_k),1) = 5 ;
                 
                 counter_k = counter_k + 1 ;
            end
            
        end
    end
end


for i = 1:polyjet_grid_dimension
    if (element_unused(i,1) == 1)
         material(1,i) = 10 ;
         
         temp_b = elements_set(i,:);
            
            counter_m = 1 ;
            
            while (counter_m < ( mesh_elements_per_polyjet_grid_element + 1 ) )
            
                 mesh_element_material_property_assignment(temp_b(counter_m),1) = 10 ;
                 
                 counter_m = counter_m + 1 ;
            end            
    end
end

mesh_element_counter = 1 ;

for  i = 1:polyjet_grid_dimension
    global_array(i,1) = i ;
    global_array(i,2) = material(1,i) ;
    for j = 3:(2 + mesh_elements_per_polyjet_grid_element)
        global_array(i,j) = mesh_element_counter ; 
        mesh_element_counter = mesh_element_counter + 1 ;
    end

end


element_set_1 = [] ;
element_set_2 = [] ;
node_set_1    = [] ;
node_set_2    = [] ;

count_node_set_column     = 16  ;        % this variable will do the counting of the appended elements in one row. In case , the row is full, we have to create a new row. 
count_element_set_column  = 16  ;

row_element_set_1      = 1 ;         % These are all temporary variables that I have done to do the counting operation 
column_element_set_1   = 1 ;         % The counters will decide whether we have to add a row to the element_set/node_set or not while appending

row_element_set_2      = 1 ;
column_element_set_2   = 1 ;

row_node_set_1         = 1 ;
column_node_set_1      = 1 ;

row_node_set_2         = 1 ;
column_node_set_2      = 1 ;

for j = 1:polyjet_grid_dimension
     if (global_array(j,2) == 5)
        
        for m = 3:(mesh_elements_per_polyjet_grid_element + 2)   
            element_set_1(row_element_set_1,column_element_set_1) = global_array(j,m) ;
            
            temp_var = global_array(j,m) ;
            
            column_element_set_1 = column_element_set_1 + 1 ;
            
            if (column_element_set_1 > count_node_set_column )
                column_element_set_1 = 1 ;
                row_element_set_1 = row_element_set_1 + 1 ;
            end
            
            for k = 1:nodes_per_element                                            % check if the node is already present in node set 1
                
                node_to_check = element_nodes(temp_var,k) ;
                
                check = ismember(node_set_1,node_to_check)  ;                  % is member returns an array of 1 or 0 1 whereever the element is present
                yes_or_no = any(check) ;                                            % any() returns logical 1 if any of the member is non-zero or logical 1
            
                if (yes_or_no == 0)                                                 % condition to see if the node is already part of the node_set_1     
                    node_set_1(row_node_set_1,column_node_set_1) = element_nodes(temp_var,k) ;
                    column_node_set_1 = column_node_set_1 + 1 ;
                    if (column_node_set_1 > count_node_set_column )
                        column_node_set_1 = 1 ;
                        row_node_set_1    = row_node_set_1 + 1 ;
                    end 
                end 
            end  
        end
        
     end
        
     if( global_array(j,2) == 10 )
          for m = 3:(mesh_elements_per_polyjet_grid_element + 2)   
              element_set_2(row_element_set_2,column_element_set_2) = global_array(j,m) ;            
              column_element_set_2 = column_element_set_2 + 1 ;
              
              temp_var = global_array(j,m) ; 
              
              if (column_element_set_2 > count_node_set_column )
                 column_element_set_2 = 1 ;
                 row_element_set_2 = row_element_set_2 + 1 ;
              end
              
              for k = 1:nodes_per_element                                            % check if the node is already present in node set 1
                
                node_to_check = element_nodes(temp_var,k) ;
                
                check = ismember(node_set_2,node_to_check)  ;                  % is member returns an array of 1 or 0 1 whereever the element is present
                yes_or_no = any(check) ;                                            % any() returns logical 1 if any of the member is non-zero or logical 1
            
                if (yes_or_no == 0)                                                 % condition to see if the node is already part of the node_set_1     
                    node_set_2(row_node_set_2,column_node_set_2) = element_nodes(temp_var,k) ;
                    column_node_set_2 = column_node_set_2 + 1 ;
                    if (column_node_set_2 > count_node_set_column )
                        column_node_set_2 = 1 ;
                        row_node_set_2    = row_node_set_2 + 1 ;
                    end 
                end 
              end  
          end
      end
end

% Now I store all these values in a text file

 
size_element_set_1 = size(element_set_1) ;
size_element_set_2 = size(element_set_2) ;
size_node_set_1    = size(node_set_1) ;
size_node_set_2    = size(node_set_2) ;

column_ele_1      = 1 ;         % These variables are simply counters that i will be using for counting operations to check the column and modify the format accordingly 
column_node_1     = 1 ;         

column_ele_2      = 1 ;
column_node_2      = 1 ;

fileID = fopen('Sets_new.txt','w');
% NODE_SET_1

% START TEXT file BY PRINTING THE COMMANDS NSET AND ELSET 
fprintf(fileID,'*Nset, nset=Set-1');
fprintf(fileID,'\n');

for i = 1:size_node_set_1(1,1)
     for j = 1:size_node_set_1(1,2)
         if (column_node_1 == 1)              % Add a space before the first number
            if ( (j<count_node_set_column) && (node_set_1(i,j+1) ~= 0) )      
                fprintf(fileID,' %d, ',node_set_1(i,j));
            else if (node_set_1(i,j) ~= 0)
                fprintf(fileID,' %d',node_set_1(i,j));
                end
            end
        else if (column_node_1 == count_node_set_column)
                 if (node_set_1(i,j) ~= 0)
                 fprintf(fileID,'%d\n',node_set_1(i,j));     % Add a condition to see if the element is 0. If it is 
                 column_node_1 = 0 ;                             % PLEASE dont add this element to the text file
                 end
             else if ( (j<count_node_set_column) && (node_set_1(i,j+1) == 0) )
                     if (node_set_1(i,j) == 0)
                        fprintf(fileID,'');
                     end
                     if (node_set_1(i,j) ~= 0)
                         fprintf(fileID,'%d',node_set_1(i,j)); 
                     end
             else
                 if (node_set_1(i,j) ~= 0)
                     fprintf(fileID,'%d, ',node_set_1(i,j)); 
                 end
                 end
             end
            end
        column_node_1 = column_node_1 + 1 ;
     end
end

% ElEMENT_SET_1
fprintf(fileID,'\n');
fprintf(fileID,'*Elset, elset=Set-1');
fprintf(fileID,'\n');

for i = 1:size_element_set_1(1,1)
    for j = 1:size_element_set_1(1,2)
        
        if (column_ele_1 == 1)              % Add a space before the first number
            if ( (j<count_element_set_column) && (element_set_1(i,j+1) ~= 0) )      
                fprintf(fileID,' %d, ',element_set_1(i,j));
            else if (element_set_1(i,j) ~= 0)
                fprintf(fileID,' %d',element_set_1(i,j));
                end
            end
        else if (column_ele_1 == count_element_set_column)
                 if (element_set_1(i,j) ~= 0)
                 fprintf(fileID,'%d\n',element_set_1(i,j));     % Add a condition to see if the element is 0. If it is 
                 column_ele_1 = 0 ;                             % PLEASE dont add this element to the text file
                 end
             else if ( (j<count_element_set_column) && (element_set_1(i,j+1) == 0) )
                     if (element_set_1(i,j) == 0)
                        fprintf(fileID,'');
                     end
                     if (element_set_1(i,j) ~= 0)
                         fprintf(fileID,'%d',element_set_1(i,j)); 
                     end
             else
                 if (element_set_1(i,j) ~= 0)
                     fprintf(fileID,'%d, ',element_set_1(i,j)); 
                 end
                 end
             end
            end
        column_ele_1 = column_ele_1 + 1 ;
    end         
end

fprintf(fileID,'\n');
fprintf(fileID,'*Nset, nset=Set-2');
fprintf(fileID,'\n');

% NODE_SET_2

for i = 1:size_node_set_2(1,1)
    for j = 1:size_node_set_2(1,2)
        if (column_node_2 == 1)              % Add a space before the first number
            if ( (j < count_node_set_column) && (node_set_2(i,j+1) ~= 0) )      
                fprintf(fileID,' %d, ',node_set_2(i,j));
            else if (node_set_2(i,j) ~= 0)
                fprintf(fileID,' %d',node_set_2(i,j));
                end
            end
        else if (column_node_2 == count_node_set_column)
                 if (node_set_2(i,j) ~= 0)
                 fprintf(fileID,'%d\n',node_set_2(i,j));     % Add a condition to see if the element is 0. If it is 
                 column_node_2 = 0 ;                             % PLEASE dont add this element to the text file
                 end
             else if ( (j < count_node_set_column) && (node_set_2(i,j+1) == 0) )
                     if (node_set_2(i,j) == 0)
                        fprintf(fileID,'');
                     end
                     if (node_set_2(i,j) ~= 0)
                         fprintf(fileID,'%d',node_set_2(i,j)); 
                     end
             else
                 if (node_set_2(i,j) ~= 0)
                     fprintf(fileID,'%d, ',node_set_2(i,j)); 
                 end
                 end
             end
            end
        column_node_2 = column_node_2 + 1 ;
    end                                                  
end

% ELEMENT_SET_2

fprintf(fileID,'\n');
fprintf(fileID,'*Elset, elset=Set-2');
fprintf(fileID,'\n');

for i = 1:size_element_set_2(1,1)
     for j = 1:size_element_set_2(1,2)
         if (column_ele_2 == 1)              % Add a space before the first number
            if ( (j<count_element_set_column) && (element_set_2(i,j+1) ~= 0) )      
                fprintf(fileID,' %d, ',element_set_2(i,j));
            else if (element_set_2(i,j) ~= 0)
                fprintf(fileID,' %d',element_set_2(i,j));
                end
            end
        else if (column_ele_2 == count_element_set_column)
                 if (element_set_2(i,j) ~= 0)
                 fprintf(fileID,'%d\n',element_set_2(i,j));     % Add a condition to see if the element is 0. If it is 
                 column_ele_2 = 0 ;                             % PLEASE dont add this element to the text file
                 end
             else if ( (j<count_element_set_column) && (element_set_2(i,j+1) == 0) )
                     if (element_set_2(i,j) == 0)
                        fprintf(fileID,'');
                     end
                     if (element_set_2(i,j) ~= 0)
                         fprintf(fileID,'%d',element_set_2(i,j)); 
                     end
             else
                 if (element_set_2(i,j) ~= 0)
                     fprintf(fileID,'%d, ',element_set_2(i,j)); 
                 end
                 end
             end
            end
        column_ele_2 = column_ele_2 + 1 ;
               % Add a space before the first number
               % Add a condition to see if the element is 0. If it is 
               % PLEASE dont add this element to the text file
               % fprintf(fileID,'%d, ',node_set_1(i,j));
     end
end
        
        disp(node_set_1) ;
    
        disp(element_set_1) ;
        
        disp(node_set_2) ;
        
        disp(element_set_2) ;
        
        fclose(fileID);
        type('Sets_new.txt')
     end

 end
 
 end

%{
% create several directory to create the new jobs. The directories shall be
% according to the volume ratios. 

% Every volume ratio directory shall contain several jobs. basically the
% positions of the assigned elements have been changed in every simu but
% the volume ratios are fixed in every iteration. 

% copy paste the .env and the .py files in every directory that you create.
% Modify the .py files according to every new directory that you create. 

% The first .inp file should be the file containing the basic information
% with the mesh elements and the sections and the set numbers should be set
% - 1 and set - 2 . $

% Within a single directory, the sections that have been assigned to a set
% are the same while the set differ only. 

% 10 - 15 jobs within a single directory each conataining  the same vol
% ratio

% Next change the directory to the one where there is the first input file

% Copy this input file to that new directory. 

% Open that input file for the purpose of read and write. 

% see for the Keyword 'element'. Take the first search of that keyword only
% Next start the choice take all the lines in the comma separated values upto the line before the first result of the Key - word NSET. 

% Clear the data in the text file called elements.dat

% save the data into the file elements.dat - fprintf . This file will be a
% temporary 

% Close the .inp file

% Put filters in the code about the new line and the case when the only
% 1ine is present create a new line for the n - set. 

% Remove the last line in case it is blank

% Remove all blank lines.

% Select the entire text file .

% Open back the .inp file for the purpose of read and write

% Search for the keyword n-Set. We do begin select from this line. 

% Search for the Keyword - Elset

% We end our select at that line. We paste the text file in this region. 

%}