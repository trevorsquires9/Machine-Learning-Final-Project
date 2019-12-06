

cvx_begin quiet
    variables x(dim)
    minimize(real(trace(A*x*x'))+b'*x)
    subject to
        min(eig([1 x'; x x*x'])) >= 0
        trace(x*x') <= 1
cvx_end