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

m = Y.shape[0]
n = Y.shape[1]
            
Y_hat = np.dot(np.transpose(U), V)

E_in = loss(Y, U, V, l)
# E_out = loss(Y_test, U, V, l)

print('k = ' + str(k))
print('l = ' + str(l))
print('E_in = ' + str(E_in))
# print('E_out = ' + str(E_out))





