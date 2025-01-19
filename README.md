# Data Science Projects

This repository contains four distinct data science projects showcasing various methodologies and their applications in analysis and prediction tasks. Below is a description of each project along with details on their outputs.

---

## 1. Singular Value Decomposition (SVD) and PCA Analysis
### Description:
- **Image Compression:** Uses SVD to compress a grayscale image (`Street_Pic.jpg`) by retaining varying numbers of singular values (e.g., 1, 4, 16, etc.).
- **Ovarian Cancer Data Analysis:** PCA is applied to an ovarian cancer dataset to reduce dimensionality and visualize the data in 3D principal component space.
- **Homework Analysis:** Performs PCA manually and using MATLAB's `pca` function on homework scores, comparing the results.

### Outputs:
- **Image Compression:** Visualizations of the compressed images for different singular value thresholds and a plot of singular values to illustrate their importance.
- **Ovarian Cancer Data Analysis:** 3D scatter plots of the dataset in PCA-reduced dimensions, both annotated and unannotated.
- **Homework Analysis:** Reduced data scatter plots and a comparison of manually computed PCA vs MATLAB's built-in PCA.

---

## 2. Receiver Operating Characteristic (ROC) Curve Analysis
### Description:
Analyzes the diagnostic performance of two features (`909` and `1591`) from an ovarian cancer dataset. The project evaluates sensitivity and specificity using various thresholds to generate ROC curves.

### Outputs:
- ROC curves for features `909` and `1591`, illustrating their classification performance.
- Area Under the Curve (AUC) values for both features to quantify their effectiveness.
- Metrics such as sensitivity, specificity, positive predictive value, and accuracy at the knee point of each ROC curve.

---

## 3. System Identification Using ARX Model
### Description:
Identifies an Auto-Regressive with eXogenous input (ARX) model for a dryer dataset, estimating system dynamics based on power input and temperature output. The model is validated using separate data splits.

### Outputs:
- Time-series plots of original and detrended data.
- Comparison of model predictions vs actual outputs for validation data.
- Estimation error plot and maximum error reported for different ARX configurations.
- Estimated model coefficients displayed for analysis.

---

## 4. Neural Network for XOR Problem
### Description:
Implements solutions for the XOR problem using:
- Linear Perceptron (Least Squares).
- Hand-coded 2-1-1 neural network using backpropagation.
- Neural networks using PyTorch (2-1-1 and 2-2-1 architectures).

### Outputs:
- Perceptron weights and accuracy on the XOR dataset.
- Manual backpropagation process results, including gradients, updated weights, and biases.
- Training loss and validation accuracy for PyTorch neural networks, with the 2-2-1 architecture achieving 100% accuracy.

---

## Repository Structure
- `SVD.m`: Code for SVD and PCA analysis.
- `ROC_Curve.m`: Code for ROC curve analysis.
- `ARX_model.m`: Code for ARX system identification.
- `NN_XOR.py`: Documented code for solving the XOR problem using neural networks.

---

## How to Use
1. Clone the repository: `git clone <repository-link>`
2. Run individual `.m` files in MATLAB for the respective projects.
3. Refer to `NN_XOR.py` for Python-based neural network implementations.

Feel free to explore and adapt the projects for your learning or research purposes!
