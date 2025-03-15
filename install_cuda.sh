#!/bin/bash


# echo "Starting installation script..."

# # Step 1: Install Python requirements
# echo "Installing Python requirements from requirements.txt..."
# pip install -r requirements-build.txt
# pip install -r requirements.txt
# if [ $? -ne 0 ]; then
#     echo "Error: Failed to install Python requirements."
#     exit 1
# else
#     echo "Python requirements installed successfully."
# fi

# # Step 2: Define LLVM version and architecture
EXTRACT_PATH="3rdparty"
FILE_NAME="clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04.tar.xz"
DOWNLOAD_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04.tar.xz"

# echo "Download URL for LLVM: ${DOWNLOAD_URL}"

# # Step 5: Create extraction directory
# echo "Creating extraction directory at ${EXTRACT_PATH}..."
# mkdir -p "$EXTRACT_PATH"
# if [ $? -ne 0 ]; then
#     echo "Error: Failed to create extraction directory."
#     exit 1
# else
#     echo "Extraction directory created successfully."
# fi

# # Step 6: Download LLVM
# echo "Downloading $FILE_NAME from $DOWNLOAD_URL..."
# curl -L -o "${EXTRACT_PATH}/${FILE_NAME}" "$DOWNLOAD_URL"
# if [ $? -ne 0 ]; then
#     echo "Error: Download failed!"
#     exit 1
# else
#     echo "Download completed successfully."
# fi

# # Step 7: Extract LLVM
# echo "Extracting $FILE_NAME to $EXTRACT_PATH..."
# tar -xf "${EXTRACT_PATH}/${FILE_NAME}" -C "$EXTRACT_PATH"
# if [ $? -ne 0 ]; then
#     echo "Error: Extraction failed!"
#     exit 1
# else
#     echo "Extraction completed successfully."
# fi

# # Step 8: Determine LLVM config path
# LLVM_CONFIG_PATH="$(realpath ${EXTRACT_PATH}/$(basename ${FILE_NAME} .tar.xz)/bin/llvm-config)"
# echo "LLVM config path determined as: $LLVM_CONFIG_PATH"
export LLVM_CONFIG_PATH=$(realpath ${EXTRACT_PATH}/$(basename ${FILE_NAME} .tar.xz)/bin/llvm-config)

# # Step 9: Clone and build TVM
# echo "Cloning TVM repository and initializing submodules..."
# # clone and build tvm
# git submodule update --init --recursive

# if [ -d build ]; then
#     rm -rf build
# fi

# mkdir build
# cp 3rdparty/tvm/cmake/config.cmake build
# cd build


# echo "Configuring TVM build with LLVM and CUDA paths..."
# echo "set(USE_LLVM \"$LLVM_CONFIG_PATH\")" >> config.cmake && \
#     CUDA_HOME=$(python -c "import sys; sys.path.append('../tilelang'); from env import CUDA_HOME; print(CUDA_HOME)") || \
#     { echo "ERROR: Failed to retrieve CUDA_HOME via Python script." >&2; exit 1; } && \
#     { [ -n "$CUDA_HOME" ] || { echo "ERROR: CUDA_HOME is empty, check CUDA installation or _find_cuda_home() in setup.py" >&2; exit 1; }; } && \
#     echo "set(USE_CUDA \"$CUDA_HOME\")" >> config.cmake

# echo "Running CMake for TileLang..."
# cmake ..
# if [ $? -ne 0 ]; then
#     echo "Error: CMake configuration failed."
#     exit 1
# fi

MINICONDA_PATH="/home/jeromeku/miniconda"

# rm -rf build
# mkdir build
# cp config.cmake build

# #UPdate PKG_CONFIG_PATH
# #export PKG_CONFIG_PATH=$MINICONDA_PATH/lib/pkgconfig:$PKG_CONFIG_PATH
# PATH_FLAGS="-DCMAKE_PREFIX_PATH=$MINICONDA_PATH -DCMAKE_INCLUDE_PATH=$MINICONDA_PATH/include -DCMAKE_LIBRARY_PATH=$MINICONDA_PATH/lib"
# ZSTD_FLAGS="-Dzstd_DIR=/home/jeromeku/miniconda/lib/cmake/zstd"
# TINFO_FLAGS="-DTINFO_LIBRARY=/home/jeromeku/miniconda/lib/libtinfo.so"
# XML2_FLAGS="-DXML2_LIBRARY=/home/jeromeku/miniconda/lib/libxml2.so"
# PKG_CONFIG_PATH=$MINICONDA_PATH/lib/pkgconfig:$PKG_CONFIG_PATH cmake --debug-find -Bbuild -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S . $PATH_FLAGS $ZSTD_FLAGS $TINFO_FLAGS $XML2_FLAGS 2>&1 | tee cmake.config.log


# #echo "Building TileLang with make..."
export LD_LIBRARY_PATH=$MINICONDA_PATH/lib:$LD_LIBRARY_PATH
export LDFLAGS="-L$MINICONDA_PATH/lib"
cmake --build build -j8 2>&1 | tee cmake.build.log

# # Calculate 75% of available CPU cores
# # Other wise, make will use all available cores
# # and it may cause the system to be unresponsive
# CORES=$(nproc)
# MAKE_JOBS=$(( CORES * 75 / 100 ))
# make -j${MAKE_JOBS}

# if [ $? -ne 0 ]; then
#     echo "Error: TileLang build failed."
#     exit 1
# else
#     echo "TileLang build completed successfully."
# fi

# cd ..

# # Step 11: Set environment variables
# TILELANG_PATH="$(pwd)"
# echo "TileLang path set to: $TILELANG_PATH"
# echo "Configuring environment variables for TVM..."
# echo "export PYTHONPATH=${TILELANG_PATH}:\$PYTHONPATH" >> ~/.bashrc
# echo "export CUDA_DEVICE_ORDER=PCI_BUS_ID" >> ~/.bashrc

# # Step 12: Source .bashrc to apply changes
# echo "Applying environment changes by sourcing .bashrc..."
# source ~/.bashrc
# if [ $? -ne 0 ]; then
#     echo "Error: Failed to source .bashrc."
#     exit 1
# else
#     echo "Environment configured successfully."
# fi

# echo "Installation script completed successfully."
