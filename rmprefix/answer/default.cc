#include <iostream>
#include <string>
#include <cstdlib>

int main() {
    for (std::string line; std::getline(std::cin, line);) {
        std::cout << line << std::endl;
    }
	exit(EXIT_SUCCESS);
}
