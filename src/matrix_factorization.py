import numpy as np

from utility import load

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
    
    # regularization portion
    left_L = (l/2) * (np.square(np.linalg.norm(U, ord = 'fro'))
                      + np.square(np.linalg.norm(V, ord = 'fro')))

    # squared loss portion
    index = (Y != 0)
    Y_hat= np.dot(np.transpose(U), V)
    right_L = 0.5 * np.sum(np.square(Y[index] - Y_hat[index]))
 
    # total loss
    L = left_L + right_L

    return L


def sgd(train, Y, U, V, l, k, eta):
    """ Stochastic Gradient Descent.

    Perform stochastic gradient descent for matrix factorization.
    
    Args:
        train (array).  Indexes for of training samples in Y.
        Y: (array).     An array with dimensions m by n, non-zero values at Y[m,n] represent training samples.
        U: (array).     An array with dimensions k by m, where k is the number of latent factors.
        V: (array).     An array with dimensions k by n, where k is the number of latent factors.
        l: (scalar).    Regularization strength.
        k: (scalar).    The number of latent factors for training.
        eta: (scalar).  Learning rate for gradient descent.

    Returns:
        U: (array).     Updated U after one epoch of stochastic gradient descent.
        V: (array).     Updated V after one epoch of stochastic gradient descent.
        
    Raises:
        None
    """
        
    m = (train[:,0])
    n = (train[:,1])

    r = np.random.permutation(range(m.shape[0]))
    
    # perform stochastic gradient descent over training samples
    for index in r:
        i = m[index]
        j = n[index]

        grad_U = (l * U[:,i]) - (V[:,j] * np.transpose(Y[i,j] - np.dot(np.transpose(U[:,i]), V[:,j])))
        grad_V = (l * V[:,j]) - (U[:,i] * np.transpose(Y[i,j] - np.dot(np.transpose(U[:,i]), V[:,j])))

        U[:,i] -= eta * grad_U
        V[:,j] -= eta * grad_V
        
    return U, V


def train_model(k, l = 0, eta = 1e-4, tol = 1e-3, max_epochs = 100, verbose = True):
    """ Matrix Factorization.

    Create a model with k-latent factors and perform stochastic gradient descent to perform matrix
    factorization. Missing samples are given a value of zero.
    
    Args:
        k: (scalar).                        The number of latent factors for training.
        l: (scalar, optional).              Regularization strength.
        eta: (scalar, optional).            Learning rate for gradient descent.
        tol: (scalar, optional).            Stopping tolerence for training based on the loss.
        max_epochs: (scalar, optional).     Maxmimum number of training epochs.
        verbose: (bool, optional).          Output training loss to shell.

    Returns:
        Y: (array).     An array with dimensions m by n, non-zero values at Y[m,n] represent training samples.
        U: (array).     An array with dimensions k by m, where k is the number of latent factors.
        V: (array).     An array with dimensions k by n, where k is the number of latent factors.
        
    Raises:
        None
    """
    
    # import datasets or previously trained models
    try:
        data = np.load('models/model_' + str(k) + '_' + str(l) + '.npz')
        epoch = data['epoch']
        Y = data['Y']
        U = data['U']
        V = data['V']
        train = data['train']
        
    except:
        data = load()

        m = data['n_users']
        n = data['n_movies']

        U = np.random.rand(k,m)
        V = np.random.rand(k,n)

        # let missing samples equal zero
        Y = np.zeros([m, n], dtype = 'float64')
                
        for i in range(data['ratings'].shape[0]):
            Y[data['ratings'][i,0], data['ratings'][i,1]] = data['ratings'][i,2]

        train = data['ratings']

        epoch = 1

    if verbose:
        print('Model ' + str(k))
        print('')

    # training
    old_L = np.Inf
    diff = tol + 1
    while epoch <= max_epochs: # and (diff > tol or diff < -tol):
        U, V = sgd(train, Y, U, V, l, k, eta)
        L = loss(Y, U, V, l)

        if verbose:
            print('Iteration: ' + str(epoch))
            print('Loss: ' + str(L))
            print('')

        diff = old_L - L
        old_L = L
        epoch += 1
        
        np.savez('models/model_' + str(k) + '_' + str(l) + '.npz', epoch = epoch, Y = Y,
                 U = U, V = V, eta = eta, l = l, k = k, train = train)

    return Y, U, V


if __name__ == '__main__':
    """ main """
    k = 20                      # number of latent factors
    eta = 1e-3,                 # learning rate
    l = 0                       # regularization lambda
    tol = 0.1                   # tolerance for convergence
    max_epochs = 600            # maximum number of training epochs


    Y, U, V = train_model(k, l, eta, tol, max_epochs)


        
        
