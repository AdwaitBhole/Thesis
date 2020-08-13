function  Homogenised() 

clc;
clear all;
close all;

global elasticity_modulus_i,global elasticity_modulus_e  ;

global mu_i,global mu_e,global kappa_i,global kappa_e, global nu_i,global nu_e;

global mu_plot; global kappa_plot; global mu_plot_new; global kappa_plot_new;

global c ;

material() ;


R_i = 0.008 ;

R_e = 0.010 ;


for i = 1:length(R_i)

    for j = 1:length(R_e)
        
        for k = 1:length(mu_i)   % iteration on every combination of material and coating
            
            shear_modulus_ratio(j,k) = (mu_i(k)/mu_e(k)) ;
            
            bulk_modulus_ratio(j,k) = (kappa_i(k)/kappa_e(k)) ;
            
            radius_ratio(i,j) = ( R_i(i)/R_e(j) ) ; 
            
            c(i,j) =  (R_i(i)/R_e(j))^3 ;
        
            radius_ratio(i,j) = R_i(i)/R_e(j) ; 
            
            radius_i(i,j) = R_i(i) ;
            
            radius_e(i,j) = R_e(j) ;
            
            x(k) =  ( ( mu_i(k)/mu_e(k) ) - 1 )  ; 
            
            eta_1(i,j,k) = ( ( ( 49 - 50 * nu_i(k) * nu_e(k) ) * x(k) ) + ( 35 * ( mu_i(k)/mu_e(k) ) * ( nu_i(k) - 2 * nu_e(k) ) ) + ( 35 * ( 2 * nu_i(k) - nu_e(k) ) ) ) ;
            eta_2(i,j,k) = ( ( 5 * nu_i(k) * ( mu_i(k)/mu_e(k) - 8 ) ) + ( 7 * ( ( mu_i(k) / mu_e(k) ) + 4 ) ) ) ;
            eta_3(i,j,k) = ( ( ( mu_i(k)/mu_e(k) ) * ( 8 - 10 * nu_e(k) ) ) + ( 7 - ( 5 * nu_e(k) ) ) ) ;

            A_1(i,j,k) = ( 8 * x(k) * ( 4 - 5 * nu_e(k) ) * eta_1(i,j,k) * c(i,j)^(10/3) )  ;
            
            A_2(i,j,k) = ( 2 * ( ( 63 * x(k) * eta_2(i,j,k) )  + 2 * eta_1(i,j,k) * eta_3(i,j,k) ) * c(i,j)^(7/3) ) ;
            
            A_3(i,j,k) = ( 252 * x(k) * eta_2(i,j,k) * c(i,j)^(5/3) )   ;
            
            A_4(i,j,k) = ( 50 * x(k) * (7 - 12 * nu_e(k) + 8 * nu_e(k)^2) * eta_2(i,j,k) * c(i,j) )   ;
            
            A_5(i,j,k) = ( 4 * ( 7 - 10 * nu_e(k) ) * eta_2(i,j,k) * eta_3(i,j,k) )  ;
            
            B_1(i,j,k) =  ( (2) * x(k) * ( 1 - 5 * nu_e(k) ) * eta_1(i,j,k) * c(i,j)^(10/3) )   ;
            
            B_2(i,j,k) =  ( 2 * ( ( 63 * x(k) * eta_2(i,j,k) ) + ( 2 * eta_1(i,j,k) * eta_3(i,j,k) ) ) * ( c(i,j)^(7/3) ) ) ;
            
            B_3(i,j,k) =  ( 252 * x(k) * eta_2(i,j,k) * ( c(i,j)^(5/3) ) ) ;
            
            B_4(i,j,k) =  ( 75 * x(k) * ( 3 - nu_e(k) ) * eta_2(i,j,k) * nu_e(k) * c(i,j) ) ;
            
            B_5(i,j,k) =  ( (3/2) * ( 15 * nu_e(k) - 7 ) * eta_2(i,j,k) * eta_3(i,j,k) ) ;
            
            C_1(i,j,k) =  ( ( 4 * x(k) * (5 * nu_e(k) - 7) * eta_1(i,j,k) * c(i,j)^(10/3) ) )  ;
            
            C_2(i,j,k) =  ( 2 * ( ( 63 * x(k) * eta_2(i,j,k) ) + (2 * eta_1(i,j,k) * eta_3(i,j,k) ) ) * c(i,j)^(7/3) ) ;
            
            C_3(i,j,k) =  ( 252 * x(k) * eta_2(i,j,k) * c(i,j)^(5/3) ) ;
            
            C_4(i,j,k) =  ( 25 * x(k) * (nu_e(k)^2 - 7) * eta_2(i,j,k) * c(i,j) )  ;
            
            C_5(i,j,k) =  ( ( 7 + 5 * nu_e(k) ) * eta_2(i,j,k) * eta_3(i,j,k) ) ;
            
            A(i,j,k)   =  ( A_1(i,j,k) - A_2(i,j,k) + A_3(i,j,k) - A_4(i,j,k) + A_5(i,j,k) ) ;
            
            B(i,j,k) =  ( - B_1(i,j,k) + B_2(i,j,k) - B_3(i,j,k) + B_4(i,j,k) + B_5(i,j,k) ) ;
            
            H(i,j,k) =  ( C_1(i,j,k) - C_2(i,j,k) + C_3(i,j,k) + C_4(i,j,k) - C_5(i,j,k) ) ;
            
            a(i,j,k) =  ( A(i,j,k) / (mu_e(k)^2) ) ;
            
            a_i = a(i,j,k) ;
            
            b(i,j,k) =  ( ( 2 * B(i,j,k) )/mu_e(k) ) ;
            
            b_i = b(i,j,k);
            
            w(i,j,k) =  H(i,j,k) ;
            
            c_i = w(i,j,k) ;
            
            mu_matrix_polynomial(i,j,k,:) = [ a_i,b_i,c_i ] ;
        
            a_polynom(i,j,k,:) =  roots( mu_matrix_polynomial(i,j,k,:) )  ;
                       
                if a_polynom(i,j,k,1)> a_polynom(i,j,k,2)
                    mu_final(i,j,k) = a_polynom(i,j,k,1) ;
                else 
                    mu_final(i,j,k) = a_polynom(i,j,k,2) ;
                end
        
            mu_plot(k) = mu_final(i,j,k) ;
            
            mu_plot_new(k) = mu_plot(k)/mu_i(k);
            
            temp(k) = ( ( kappa_i(k) - kappa_e(k) ) / ( kappa_e(k) + (4/3) * mu_e(k) ) ) ;
           
            temp_den(i,j,k) = ( 1 + ( ( 1 - c(i,j) ) * temp(k) ) ) ;
            
            kappa_bar_temp(i,j,k)  =  ( c(i,j)/temp_den(i,j,k) )  ;
            
            kappa_bar_final(i,j,k) = ( ( kappa_bar_temp(i,j,k) * ( kappa_i(k) - kappa_e(k) ) ) + kappa_e(k) ) ;
           
            kappa_plot(k) =  kappa_bar_final(i,j,k) ;
            
            kappa_plot_new(k) = kappa_plot(k)/(kappa_i(k));

        end  
    end
end

hold on;
figure; 
plot(mu_plot_new,radius_ratio) ;

hold on;
figure ;
plot(kappa_plot_new,radius_ratio) ;

end