#include "fileopener.h"
#include <QTextStream>

FileOpener::FileOpener()
{

}

QMap<QString, QVariant> FileOpener::static_infos()
{
    return QMap<QString, QVariant>({
                                      {"name", "FileOpener"},
                                      {"desc", "Open and manipulate files"},
                                      {"inputs_count", "3"},
                                      {"outputs_count", "2"}
                                  });
}

void FileOpener::openFile(QString filePath)
{
    QFile file(filePath);

    if (!file.open(QIODevice::ReadWrite | QIODevice::Text))
        return;

    QTextStream in(&file);
    emit output(in.readAll().toUtf8());

    file.close();
}