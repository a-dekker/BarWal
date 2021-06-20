#ifndef SRC_OSREAD_H_
#define SRC_OSREAD_H_

#include <QObject>
#include <QProcess>

class Launcher : public QObject {
    Q_OBJECT
    Q_PROPERTY(
        QString message READ message WRITE setMessage NOTIFY
            outputReceived)  // this makes message available as a QML property

   public:
    explicit Launcher(QObject *parent = 0);
    ~Launcher();
    Q_INVOKABLE QString launch(const QString &program);
    Q_INVOKABLE QString launch_stderr(const QString &program);
    Q_INVOKABLE void launch_async(const QString &program);
    QString message() const;
    void setMessage(const QString &value);
   public slots:
    void setMessageCall();

   private:
    QProcess *m_process;
    QProcess *m_process_async;
    QString m_message;

   signals:
    void outputReceived();
};

#endif  // SRC_OSREAD_H_
