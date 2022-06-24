classdef Eye_test < Bench
   
	% attempt to improve
	% Optometrika default
	% eye model 
    
    properties ( Constant )

        % anterior cornea
        Cornea1D = 11  
        Cornea1R = 7.77
        Cornea1k = -0.18
        Cornea1x = 0.0  
        
        % posterior cornea
        Cornea2D = 11
        Cornea2R = 6.4
        Cornea2k = -0.6
        Cornea2x = 0.5
        
        % pupil
        %PupilDout = 11    % outer pupil diameter 
        %Pupilx   = -10.25 % -9.85  % Aqueous thickness is 3.05 (Goncharov, 2009 30-year old and also Escudero-Sanz & Navarro). 
                          % I shifted pupil plane .15 mm anterior to
                          % prevent front lens surface getting into the
                          % pupil surface for the smallest pupil (2mm) and
                          % the strongest accommodation (7D)
        % lens
        Lens1D = 11
        Lens1x = 0.5 + 3.16
        
        Lens2D = 11
    
        % retina
        RetinaR  = -12.94
        Retinak  = 0.275
        Retinax  = 0.5 + 3.16 + 1.5496 + 16.7889
        
    end
    
    properties            % variable depending on accommodation
        
        Lens1R = 10.38
        Lens1k = -3.88
        
        Lens2R = - 5.38
        Lens2k = -1.5895
        Lens2x = Eye_test.Lens1x + 2.3244

        image = [];
        
        elem_n = zeros(1, 2); % 1 : lens1; 2 : lens2;
        
    end
    
    methods
          
        function self = Eye_test()
            
            % compound eye elements
            
            % cornea
            cornea1 = Lens( [ self.Cornea1x 0 0 ], self.Cornea1D, self.Cornea1R, self.Cornea1k, { 'air' 'cornea' } );
            self.cnt = self.cnt + 1;
            self.elem{ self.cnt } = cornea1;
            cornea2 = Lens( [ self.Cornea2x 0 0 ], self.Cornea2D, self.Cornea2R, self.Cornea2k, { 'cornea' 'aqueous' } );
            self.cnt = self.cnt + 1;
            self.elem{ self.cnt } = cornea2;
            
            % pupil
            % pupil = Aperture( [ self.Pupilx 0 0 ], [ self.PupilD, self.PupilDout, 1000 ] ); % the third diameter is the one actually used for tracing, the second just to draw
            %pupil = Lens( [ self.Pupilx 0 0 ], [ self.PupilD, -1.77*self.RetinaR ], -self.RetinaR, self.Retinak, { 'cornea' 'soot' } ); % pupil extends around the retina to simulate the opaque choroid
            %self.cnt = self.cnt + 1;
            %self.elem{ self.cnt } = pupil;
            
            lens1 = Lens( [ self.Lens1x 0 0 ], self.Lens1D, self.Lens1R, self.Lens1k, { 'aqueous' 'lens' } );
            self.cnt = self.cnt + 1;
            self.elem{ self.cnt } = lens1;
            self.elem_n( 1 ) = self.cnt;
            
            lens2 = Lens( [ self.Lens2x 0 0 ], self.Lens2D, self.Lens2R, self.Lens2k, { 'lens' 'vitreous' } );
            self.cnt = self.cnt + 1;
            self.elem{ self.cnt } = lens2;
            self.elem_n( 2 ) = self.cnt;
            
            % retina
            retina = Retina( [ self.Retinax 0 0 ], self.RetinaR, self.Retinak );
            % retina.rotate( [ 0 0 1 ], self.RetinaRotz * pi / 180 );
            self.cnt = self.cnt + 1;            
            self.elem{ self.cnt } = retina;
            self.image = retina.image;
                        
        end
                
        function self = spec_eye(self, D, A)
            % D diopters
            % A age
            
            self.Lens1R = 1/(1/(12.7 - 0.058*A) + 0.0077*D);
            self.Lens1k = -2.8 +0.025*A - 0.0013*A*A - 0.25*D;
            
            self.Lens2R = -1/(1/(5.9 - 0.013*A) + 0.0043*D);
            self.Lens2k = 0.1 - 0.06*A;
            self.Lens2x = self.Lens1x + 2.93 + 0.0236*A +D*(0.058 - 0.0005*A);
            
            % update lenses
            lens1 = Lens( [ self.Lens1x 0 0 ], self.Lens1D, self.Lens1R, self.Lens1k, { 'aqueous' 'lens' } );
            self.elem{ self.elem_n( 1 ) } = lens1;
            
            lens2 = Lens( [ self.Lens2x 0 0 ], self.Lens2D, self.Lens2R, self.Lens2k, { 'lens' 'vitreous' } );
            self.elem{ self.elem_n( 2 ) } = lens2;
            
        end

    end
    
end

