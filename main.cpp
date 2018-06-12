/*: # main.cpp
 * main.cpp is the entry point to the application. It parses the command line
 * arguments and lets Qt handle the rest. */
#include <QApplication>
#include "mainwindow.h"

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	MainWindow w(nullptr, argc>1 ? argv[1] : "default_config.cfg");
	w.show();   
	return a.exec();
}
