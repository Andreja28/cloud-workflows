function [Inew] = rot2retour(theta1,phi1,I)



% new base-vectors
e1 = [cos(phi1)*cos(theta1) ; sin(phi1)*cos(theta1) ; -sin(theta1)];
e2 = [-sin(phi1)         ; cos(phi1)          ;  0       ];
e3 = [cos(phi1)*sin(theta1) ; sin(phi1)*sin(theta1) ;  cos(theta1)];

% components nij
%
nn(1,1) = e1(1,1) ;
nn(2,1) = e1(2,1) ;
nn(3,1) = e1(3,1) ;
%
nn(1,2) = e2(1,1) ;
nn(2,2) = e2(2,1) ;
nn(3,2) = e2(3,1) ;
%
nn(1,3) = e3(1,1) ;
nn(2,3) = e3(2,1) ;
nn(3,3) = e3(3,1) ;
%
%nn=nn';
%
for i=1:3
    for j=1:3
        for k=1:3
            for l=1:3
                Inew(i,j,k,l) = 0 ;
                for m=1:3
                    for n=1:3
                        for p=1:3
                            for q=1:3
                                Inew(i,j,k,l) = Inew(i,j,k,l) + ...
                                    nn(i,m)*nn(j,n)*nn(k,p)*nn(l,q)*I(m,n,p,q) ;
                            end
                        end
                    end
                end
            end
        end
    end
end
