#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMdiArea>
#include <QMdiSubWindow>
#include <QDialog>
#include <QFileDialog>
#include "subwindows/taskmanagerwindow.h"
#include "viewportwindow.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

signals:
    //void fileChoosed(retdec::fileformat::FileFormat* file);

private slots:
    void on_actionExit_triggered();

    void on_actionOpen_triggered();

    void on_actionProgram_header_toggled(bool arg1);

    void on_actionFullscreen_triggered();

    void on_actionTest_Connection_triggered();

    void on_actionTask_Manager_triggered();

private:
    Ui::MainWindow *ui;
    ViewPortWindow *m_viewPort = nullptr;
    TaskManagerWindow *m_taskManager = nullptr;

};
#endif // MAINWINDOW_H
