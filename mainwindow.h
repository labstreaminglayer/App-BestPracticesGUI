#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "ui_mainwindow.h"
#include <QMainWindow>
#include <memory> //for std::unique_ptr
#include <atomic>

//: to keep our include lists and compile times short we only provide forward
//: declarations for classes we only have pointers to
namespace Ui { class MainWindow; }
namespace std { class thread; }

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent, const char* config_file);
	~MainWindow() override;

private slots:
	void closeEvent(QCloseEvent *ev) override;
	void toggleRecording(void);

private:
	// function for loading / saving the config file
	void load_config(const QString& filename);
	void save_config(const QString& filename);
	//: `std::unique_ptr` prevents us from copying objects we should only have
	//: once and automatically deletes the objects when the `unique_ptr` goes
	//: out of scope.
	std::unique_ptr<std::thread> recording_thread;

	std::unique_ptr<Ui::MainWindow> ui;	// window pointer
	std::atomic<bool> shutdown{false};  // flag indicating whether the recording thread should quit
};

#endif // MAINWINDOW_H
