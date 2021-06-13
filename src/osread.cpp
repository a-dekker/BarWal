#include "osread.h"
#include <sys/types.h>
#include <iostream>

Launcher::Launcher(QObject *parent)
    : QObject(parent),
      m_process(new QProcess(this)),
      m_process_async(new QProcess(this)) {}

QString Launcher::message() const { return m_message; }

void Launcher::launch_async(const QString &program) {
    // Wait if another process is still running
    m_process_async->waitForFinished(5000);
    m_process_async->start(program);
    if (!m_process_async->waitForStarted(4000)) {
        std::cout << "Process did not start." << std::endl;
    }
    connect(m_process_async, SIGNAL(readyRead()), this, SLOT(setMessageCall()));
}

QString Launcher::launch(const QString &program) {
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}

void Launcher::setMessageCall() {
    // We cannot have parameters, because readyRead has none
    // But setMessage needs one argument, so we have this function first
    if (m_process_async->bytesAvailable() > 0) {
        setMessage("dummy");
    }
}

void Launcher::setMessage(const QString &value) {
    QByteArray bytes = m_process_async->readAllStandardOutput();
    m_message = QString::fromLocal8Bit(bytes);
    // std::cout << "[" << m_message.toStdString() << "]" << std::endl;
    outputReceived();
}

Launcher::~Launcher() {}
