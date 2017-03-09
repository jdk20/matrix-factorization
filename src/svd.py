import numpy as np
import scipy.io

def loss(Y, U, V, l):
    """ Squared-loss function.

    Evaluate the loss for training samples in Y, using U and V. The loss consists of a regularization portion
    (left_L) and a squared-loss term (right_L).
    
    Args:
        Y: (array).     An array with dimensions m by n, non-zero values at Y[m,n] represent training samples.
        U: (array).     An array with dimensions k by m, where k is the number of latent factors.
        V: (array).     An array with dimensions k by n, where k is the number of latent factors.
        l: (scalar).    Regularization strength.

    Returns:
        L: (scalar).    Squared loss with regularization.
        
    Raises:
        None
    """
    
    m = Y.shape[0]
    n = Y.shape[1]
    
    # squared loss
    index = (Y != 0)
    Y_hat= np.dot(np.transpose(U), V)
    L = 0.5 * np.sum(np.square(Y[index] - Y_hat[index]))

    return L


""" main """
k = 20                  # number of latent factors
l = 0                   # regularization lambda

data = np.load('models/model_' + str(k) + '_' + str(l) + '.npz')
epoch = data['epoch']
Y = data['Y']
U = data['U']
V = data['V']
train = data['train']
l = data['l']

m = Y.shape[0]                          # m users, U
n = Y.shape[1]                          # n movies, V
            
Y_hat = np.dot(np.transpose(U), V)
E_in = loss(Y, U, V, l)

# orthogonal, square matrix where rows are orthogonal and have unit norm (orthonormal)
# A^T*A = A*A^T = I and A^-1 = A^T, inverse is very cheap to compute
#
# A (orthogonal, 20 by 20 matrix), left-singular vectors, eigenvectors of V*V^T, latent factors of movie matrix
# s (singular values, 20 by 1682 diagonal matrix), singular values of V, square roots of eigenvalues of A^T*T or A*A^T
# B (orthogonal, 1682 by 1682 matrix), right-singular vectors, eigenvectors of V^T*V
A, s, B = np.linalg.svd(V, full_matrices = True, compute_uv = True)

V_hat = np.dot(np.transpose(A[:,0:2]), V)
U_hat = np.dot(np.transpose(A[:,0:2]), U)

scipy.io.savemat('build/svd.mat', mdict = {'V_hat': V_hat, 'U_hat': U_hat, 'U': U, 'V': V})

