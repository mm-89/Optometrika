function PSF()

% programma per testare il diametro
% del cono luce arrivante sulla cornea
% con diversi diametri della pupilla,
% utilizzando una luce puntiforme.

% PSF (Point Spread Function)

mean = zeros(1, 19);
mean2 = zeros(1, 19);
std = zeros(1, 19);

for i = 1 : 5

    res = zeros(1, 19);
    for j = 0 : 18

        viewing_distance = 1000;
        pupil_diameter = 0.5 + j/4;
        nrays = 100000;
        nd = 100;
        ld = linspace(10.610, 9.5, nd );

        % create some rays
        rays_in = Rays( nrays, 'source', [ -(viewing_distance + 13.3) 0 0 ], [ 1 0 0 ], 0.06, 'random', 'air');

        dv = zeros( nd, 1 );
        for i = 1 : nd
            % create an optical bench
            bench = Bench;
            lens_diameter = ld( i );
            eye = Eye( lens_diameter, pupil_diameter ); % eye accommodating at infinity
            %eye.eye_lens_vol( lens_diameter )
            bench.append( eye );    
            % trace the rays
            rays_through = bench.trace( rays_in );
            [ ~, dv( i ) ] = rays_through( end ).stat; % record standard deviation of the bundle on the retina
        end

        [ mdv, mi ] = min( dv );

        %set( gca, 'XDir', 'reverse' );

        % draw the result for the optimal pupil diameter
        bench = Bench;
        eye = Eye( ld( mi ), pupil_diameter );
        bench.append( eye );
        rays_in = Rays( nrays, 'source', [ -(viewing_distance + 13.3) 0 0 ], [ 1 0 0 ], 0.006, 'random', 'air');
        rays_through = bench.trace( rays_in );
        %bench.draw( rays_through, 'lines' );

        aaa = rays_through( end ).r( :, 2:3 );

        mask_inf = ~isnan(aaa);
        mask_inf = mask_inf( : , 1 ) .* mask_inf( :, 2 );
        aaa = aaa( mask_inf==1 , :);

        [a, b] = boundary(aaa); % b is the circle area, in mm^2
        diam = 2 * sqrt(b/pi); % in mm
        disp(diam);
        res( j + 1 ) = diam ;

    end
        
    mean = mean + res;
    mean2 = mean2 + res.^2;
     
end

mean = mean ./ 5;
std = sqrt(mean2 ./5 - mean.^2);
axis = linspace(0.5, 5, 19);

% translate in um
mean = mean .* 1000;
std = std .* 1000;

errorbar(axis,mean,std);
hold on

% true coordinates with Navarro model
% on Handbook of optical system (2011)

% le coordinate sono prese da un tool online
% https://www.mobilefish.com/services/record_mouse_coordinates/record_mouse_coordinates.php

x = linspace(0.5, 5, 10);
y = 297.*ones(1, 10) - [ 292 285 283 282 285 284 269 244 205 153 ];
y = 5 * y / 52;

plot(x, y);
hold off

legend('Simulated','reference')
xlabel("D_{iris} [mm]");
ylabel("D_{spot} [um]");

end