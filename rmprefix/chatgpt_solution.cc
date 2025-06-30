// rmprefix.cc
#include <iostream>
#include <string>
#include <cstdlib>  // for EXIT_SUCCESS and EXIT_FAILURE

int main() {
    std::string line;

    try {
        while (std::getline(std::cin, line)) {
            // Find the index of the first non-space or non-tab character
            size_t first_non_ws = line.find_first_not_of(" \t");
            if (first_non_ws != std::string::npos) {
                std::cout << line.substr(first_non_ws) << std::endl;
            } else {
                // Line consists entirely of whitespace
                std::cout << std::endl;
            }
        }
    } catch (...) {
        // If any unexpected error occurs
        std::cerr << "An error occurred while processing input." << std::endl;
        exit(EXIT_FAILURE);
    }

    exit(EXIT_SUCCESS);
}
