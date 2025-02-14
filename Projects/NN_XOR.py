# Import Libraries
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset
import numpy as np

# Part A: Dataset Generation
# # XOR LOGIC:
# X = [
#     R+R, # Red-Red -> 0
#     G+G, # Green-Green -> 0
#     R+G, # Red-Green -> 1
#     G+R, # Green-Red -> 1
# ]
# Y = [0,0,1,1]

R = [1]
G = [0]

# Implementing the above XOR logic
def xor_logic(color1, color2):
    return int((color1 == R and color2 == G) or (color1 == G and color2 == R))

# Generate XOR dataset
def dataset(num_samples):
    x = []
    y = []
    for _ in range(num_samples):
        color1 = R if np.random.rand() > 0.5 else G
        color2 = R if np.random.rand() > 0.5 else G
        x.append(color1 + color2)  # Concatenate two RGB values
        y.append(xor_logic(color1, color2))
    return np.array(x, dtype=float), np.array(y, dtype=float)

# Create dataset
num_samples = 1000;
x_data, y_data = dataset(num_samples)

# Split the dataset into a 80% tranining; 20% Validation
split_ratio = 0.8
split_idx = int(split_ratio * num_samples)

# Training Dataset
x_train = x_data[:split_idx]
y_train = y_data[:split_idx]

# Validation Dataset
x_val = x_data[split_idx:]
y_val = y_data[split_idx:]

# Part B: Linear Perceptron (LP)
# Equal Distribution for Linear Perceptron
lp_split_idx = int(0.5 * num_samples)
x_lp_train = x_data[:lp_split_idx]
y_lp_train = y_data[:lp_split_idx]
x_lp_val = x_data[lp_split_idx:]
y_lp_val = y_data[lp_split_idx:]

# Solve for weights using Least Squares estimation
lp_weights = np.linalg.pinv(x_lp_train) @ y_lp_train
print(f"Linear Perceptron Weights: {lp_weights}")

# Compute predictions on the validation set
y_lp_pred = x_lp_val@ lp_weights

# Threshold predictions to binary values
y_lp_pred = (y_lp_pred > 0.5).astype(int)

# Calculate accuracy
lp_accuracy = np.mean(y_lp_pred == y_lp_val)
print(f"Linear Perceptron Accuracy (Least Squares): {lp_accuracy * 100:.2f}%")

# Part C 1: 2-1-1 NN by hand:
# Sigmoid activation and its derivative
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_derivative(x):
    sig = sigmoid(x)
    return sig * (1 - sig)

# Initialize random weights and biases
np.random.seed(42)

# Input --> Hidden Layer
W1 = np.random.rand(1, 2)
print(f"Initial Hidden Layer Weights: {W1}")
b1 = np.random.rand(1)
print(f"Initial Hidden Layer Bias: {b1}")

# Hidden Layer --> Output
W2 = np.random.rand(1, 1)
print(f"Initial Output Layer Weights: {W2}")
b2 = np.random.rand(1)
print(f"Initial Output Layer Bias: {b2}")

# Learning rate -step of the gradient descent-
eta = 0.01

# 1 iteration by hand
x_sample = x_train[0]
print(f"X: {x_sample}")
y_true = y_train[0]
print(f"Y: {y_true}")

# ---- Feedforward ----
# Hidden layer
z1 = np.dot(W1, x_sample.T) + b1  # Dot product + bias
print(f"Hidden Input: {z1}")
h_output = sigmoid(z1)
print(f"Hidden Output: {h_output}")

# Output layer
z2 = np.dot(W2, h_output) + b2
print(f"Output Input: {z2}")
y_pred = sigmoid(z2)
print(f"Prediction (Output output): {y_pred}")

# # ---- Backpropagation ----
# Output layer error and gradients
error = y_true - y_pred
print(f"The error: {error}")

loss = - (y_true * np.log(y_pred) + (1 - y_true) * np.log(1 - y_pred))
print(f"Loss: {loss}")

# Output-Hidden Layer error
# partiald(L) / partiald(W2) = partiald(L) / partiald(y_pred) * sigmoid'(z2) * h_output
# partiald(L) / partiald(y_pred) = ypred - y_true = -error
delta2 = -error * sigmoid_derivative(z2)
dW2 = delta2* h_output
print(f"Gradient descent for W2: {dW2}")
db2 = delta2
print(f"Gradient descent for b2: {db2}")

# # Hidden layer gradients
# Hidden Layer error delta
# delta = error * sigmoid_derivative(y_pred) * W2.T

# Hidden-Input error
delta1 = (delta2 * W2.T) * sigmoid_derivative(z1)
dW1 = np.outer(delta1, x_sample)
print(f"Gradient descent for W1: {dW1}")
db1 = delta1
print(f"Gradient descent for b1: {db1}")

# # ---- Update Weights ----
W2 -= eta * dW2
b2 -= eta * db2[0]
W1 -= eta * dW1
b1 -= eta * db1[0]

# Print updated weights and biases
print("Updated Weights and Biases:")
print(f"W1: {W1}, b1: {b1}")
print(f"W2: {W2}, b2: {b2}")

# Part C 2: Code for 2-1-1 NN
# ---- Feedforward Function ----
def feedforward(x, W1, b1, W2, b2):
    # Hidden layer
    z1 = np.dot(W1, x.T) + b1
    h_output = sigmoid(z1)

    # Output layer
    z2 = np.dot(W2, h_output) + b2
    y_pred = sigmoid(z2)
    return z1, h_output, z2, y_pred

# ---- Backpropagation Function ----
def backpropagation(x, y_true, z1, h_output, z2, y_pred, W2):
    # Compute errors
    error = y_true - y_pred
    delta2 = -error * sigmoid_derivative(z2)
    dW2 = np.dot(delta2, h_output.T)
    db2 = np.sum(delta2, axis=1)

    delta1 = (delta2.T @ W2) * sigmoid_derivative(z1.T)
    dW1 = np.dot(delta1.T, x)
    db1 = np.sum(delta1, axis=0)

    return dW1, db1, dW2, db2

epochs = 100
for epoch in range(epochs):
    # Feedforward
    z1, h_output, z2, y_pred = feedforward(x_train, W1, b1, W2, b2)
    # Backpropagation
    dW1, db1, dW2, db2 = backpropagation(x_train, y_train, z1, h_output, z2, y_pred, W2)
    # Update weights and biases
    W1 -= eta * dW1
    b1 -= eta * db1
    W2 -= eta * dW2
    b2 -= eta * db2
    # Compute loss
    loss = -np.mean(y_train * np.log(y_pred) + (1 - y_train) * np.log(1 - y_pred))
    # Print loss every 10 epochs
    if (epoch + 1) % 10 == 0:
        print(f"Epoch {epoch+1}/{epochs}, Loss: {loss:.4f}")
        print(f"W1: {W1}, b1: {b1}")
        print(f"W2: {W2}, b2: {b2}")
def evaluate(x, y, W1, b1, W2, b2):
    _, _, _, y_pred = feedforward(x, W1, b1, W2, b2)
    y_pred_binary = (y_pred > 0.5).astype(int)
    accuracy = np.mean(y_pred_binary == y)
    return accuracy

# Evaluate on training and validation datasets
train_accuracy = evaluate(x_train, y_train, W1, b1, W2, b2)
val_accuracy = evaluate(x_val, y_val, W1, b1, W2, b2)
print(f"Training Accuracy: {train_accuracy * 100:.2f}%")
print(f"Validation Accuracy: {val_accuracy * 100:.2f}%")

# Part D: NN using PyTorch
# Dataset preparation
x_train_tensor = torch.tensor(x_train, dtype=torch.float32)  # Training features
y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)  # Training labels
x_val_tensor = torch.tensor(x_val, dtype=torch.float32)      # Validation features
y_val_tensor = torch.tensor(y_val, dtype=torch.float32).unsqueeze(1)      # Validation labels

# Create DataLoaders
train_dataset = TensorDataset(x_train_tensor, y_train_tensor)
val_dataset = TensorDataset(x_val_tensor, y_val_tensor)

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False)

class NN_2_1_1(nn.Module):
    def __init__(self):
        super(NN_2_1_1, self).__init__()
        self.hidden = nn.Linear(2, 1)
        self.output = nn.Linear(1, 1)

    def forward(self, x):
        h = torch.sigmoid(self.hidden(x))
        y_pred = torch.sigmoid(self.output(h))
        return y_pred

class NN_2_2_1(nn.Module):
    def __init__(self):
          super(NN_2_2_1, self).__init__()
          self.hidden = nn.Linear(2, 2)
          self.output = nn.Linear(2 , 1)

    def forward(self, x):
          h = torch.sigmoid(self.hidden(x))
          y_pred = torch.sigmoid(self.output(h))
          return y_pred

def train_model(model, train_loader, val_loader, epochs, learning_rate):
    criterion = nn.BCELoss()  # Binary cross-entropy loss
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)

    for epoch in range(epochs):
        model.train()  # Set model to training mode
        train_loss = 0

        for x_batch, y_batch in train_loader:
            optimizer.zero_grad()  # Clear gradients
            y_pred = model(x_batch)  # Forward pass
            loss = criterion(y_pred, y_batch)  # Compute loss
            loss.backward()  # Backpropagation
            optimizer.step()  # Update weights
            train_loss += loss.item()

        # Validation
        model.eval()  # Set model to evaluation mode
        val_loss = 0
        correct = 0
        total = 0

        with torch.no_grad():
            for x_batch, y_batch in val_loader:
                y_pred = model(x_batch)
                val_loss += criterion(y_pred, y_batch).item()
                y_pred_binary = (y_pred > 0.5).float()  # Threshold for binary classification
                correct += (y_pred_binary == y_batch).sum().item()
                total += y_batch.size(0)

        # Compute metrics
        train_loss /= len(train_loader)
        val_loss /= len(val_loader)
        val_accuracy = correct / total * 100
        if (epoch + 1) % 10 == 0 or epoch == epochs - 1:
          print(f"Epoch {epoch+1}/{epochs}, Train Loss: {train_loss:.4f}, Val Loss: {val_loss:.4f}, Val Accuracy: {val_accuracy:.2f}%")

model_2_1_1 = NN_2_1_1()
print("Training 2-1-1 Neural Network")
train_model(model_2_1_1, train_loader, val_loader, epochs=100, learning_rate=eta)

model_2_2_1 = NN_2_2_1()
print("\nTraining 2-2-1 Neural Network")
train_model(model_2_2_1, train_loader, val_loader, epochs=100, learning_rate=eta)
