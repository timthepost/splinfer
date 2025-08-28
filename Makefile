# Part of llama's process we've inherited
GIT_COMMIT := bcbddcd5

# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wpedantic -Iinclude -O2
CXXFLAGS += -Wno-unused-function -Wno-unused-variable

# Linker flags and libraries
# You'll link against libllama.so, so we add -lllama
LDFLAGS =
LDLIBS = -lllama -lggml -lggml-base

# Project structure
TARGET = splinferd
SRCDIR = src
OBJDIR = obj

# Automatically find all .cpp files in the source directory
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
# Create a list of object files in the obj directory
OBJECTS = $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SOURCES))

# Default target: build the executable
all: $(TARGET)

# Rule to link the final executable
$(TARGET): $(OBJECTS)
	@echo "  LD $@"
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)
	@echo "Build complete: ./$(TARGET)"

# Rule to compile a .cpp file into a .o object file
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR) # Create the obj directory if it doesn't exist
	@echo " CXX $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up build artifacts
clean:
	@echo "  RM $(OBJDIR) $(TARGET)"
	@rm -rf $(OBJDIR) $(TARGET)

# Phony targets are not files
.PHONY: all clean
