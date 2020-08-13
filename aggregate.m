function aggregate()

Homogenised();

v_1 = 0.1:0.01:0.9;              % volume proportion of the first material

global mu_plot; global kappa_plot; global mu_plot_new; global kappa_plot_new ;

%{

mu_1 = [470.2546,546.0055,525.1519,805.6842] ;       % shear modulus of coated sphere taken from code 1 (material_1 + coating)

mu_2 = [830.4790,830.4790,830.4790,830.4790]  ;      % shear modulus of coated sphere taken from code 1 (material_2 + coating)

kappa_1 = [2.3810e3,2.7981e3,3.1092e3,3.7284e3] ;       % shear modulus of coated sphere taken from code 1 (material_1 + coating)

kappa_2 = [3.7105e3,3.7105e3,3.7105e3,3.7105e3]  ;      % shear modulus of coated sphere taken from code 1 (material_2 + coating)

%}

%{
v_1 = 0.4;              % volume proportion of the first material

mu_1 = [470.2546,546.0055,525.1519,805.6842,830.4790] ;       % shear modulus of coated sphere taken from code 1 (material_1 + coating)

mu_2 = [830.4790,805.6842,546.0055,525.1519,470.2546]  ;      % shear modulus of coated sphere taken from code 1 (material_2 + coating)

kappa_1 = [2.3810e3,2.7981e3,3.1092e3,3.7284e3,3.7105e3] ;       % shear modulus of coated sphere taken from code 1 (material_1 + coating)

kappa_2 = [3.7105e3,3.7284e3,2.7981e3,3.1092e3,2.3810e3]  ;      % shear modulus of coated sphere taken from code 1 (material_2 + coating)

%}

for i = 1:length(v_1)
    
    for j = 1:length(mu_1)
        
         v_2(i)  = 1 - v_1(i) ;
         
        volume_ratio(i,j) = v_1(i)/v_2(i) ;
	
		shear_strength_ratio(i,j) = mu_1(j)/mu_2(j) ;
        
        bulk_modulus_ratio(i,j) = kappa_1(j)/kappa_2(j) ;
        
        
		
        mu_i(i,j) = v_1(i) * mu_1(j) + v_2(i) * mu_2(j) ;
        
        kappa_i(i,j) = v_1(i) * kappa_1(j) + v_2(i) * kappa_2(j) ;
        
        
		
		a_4(i,j) = ( -8/15 );
        
        a_3(i,j) = ( ( ( 4/3 ) * mu_i(i,j) ) - ( ( 4/5 ) * ( mu_1(j) + mu_2(j) ) ) - ( (2/5) * ( kappa_1(j) + kappa_2(j) ) ) - ( (1/5) * kappa_i(i,j) ) )   ;
        
        a_2(i,j) = ( ( ( 4/5 ) * mu_1(j) * mu_2(j) ) - ( ( 9/20 ) * kappa_1(j) * kappa_2(j) )  +  ( ( kappa_1(j) + kappa_2(j) ) * mu_i(i,j) ) - ( ( 1/5 ) * ( 3 * ( kappa_1(j) + kappa_2(j) ) - kappa_i(i,j) ) * ( mu_1(j) + mu_2(j) ) ) )  ;
        
        a_1(i,j) = ( ( ( 3/4 ) * kappa_1(j) * kappa_2(j)  * ( mu_i(i,j) - ( ( 2/5 ) * ( mu_1(j) + mu_2(j) ) ) ) )  + ( (1/5) * mu_1(j) * mu_2(j) * ( ( 3 * ( kappa_1(j) + kappa_2(j) ) ) - kappa_i(i,j) ) ) )  ;
        
        a_0(i,j) = ( ( 3/10 ) * kappa_1(j) * kappa_2(j) * mu_1(j) * mu_2(j) ) ;
        
		
		
        mu_matrix_polynomial(i,j,:) = [ a_4(i,j), a_3(i,j), a_2(i,j), a_1(i,j), a_0(i,j) ] ;
        
        a_polynom(i,j,:) =  roots( mu_matrix_polynomial(i,j,:) ) ;
        
		% How do you know if only 1 root is positive
        for h = 1:4
            if (a_polynom(i,j,h)>0)
                shear_strength_aggregate(i,j) = a_polynom(i,j,h) ;                
            end
        end
        
        mu_plot(i,j) = shear_strength_aggregate(i,j) ;
        
        num_temp(i,j) = ( ( kappa_i(i,j) * shear_strength_aggregate(i,j) ) + ( ( 3/4 ) * kappa_1(j) * kappa_2(j) ) ) ;
        den_temp(i,j) = ( shear_strength_aggregate(i,j) + ( ( 3/4 ) * ( kappa_1(j) + kappa_2(j) - kappa_i(i,j) ) ) ) ;
        kappa_agg(i,j) = (num_temp(i,j)/den_temp(i,j)) ;
        
        kappa_plot(i,j) = kappa_agg(i,j) 
    end 
end