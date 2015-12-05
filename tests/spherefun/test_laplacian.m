function pass = test_laplacian( )

tol = 1e4*chebfunpref().techPrefs.eps;

k = 1;
for ell = [1 2 4 5 7 8 9]
    for m = -ell:ell
        f = spherefun.sphharm(ell,m);
        lap = laplacian(f);
        pass(k,1) = numel(lap.pivotValues) == numel(f.pivotValues);
        err(k) = SampleError( -ell*(ell+1)*f, lap )/(ell*(ell+1));
        pass(k,2) = SampleError( -ell*(ell+1)*f, lap ) < ell*(ell+1)*tol;
        k = k+1;
    end
end
pass = pass(:);

% Gaussian
lam0 = pi/sqrt(2); th0 = (sqrt(5) - 2)/2; sig2 = 1;
r2 = @(lam,th) 2*(1 - (sin(th)*sin(th0)).*cos(lam-lam0)-cos(th)*cos(th0));
f = @(lam,th) exp(-sig2*r2(lam,th));
exact = @(lam,th) sig2*exp(-sig2*r2(lam,th)).*(-4 + r2(lam,th).*(2 - sig2*(-4 + r2(lam,th))));
lap = laplacian(spherefun(f));
pass(end+1) = SampleError(exact,lap) < 10*tol;

end