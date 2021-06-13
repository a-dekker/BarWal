#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = 0);
    Q_INVOKABLE void setValue(const QString & key, const QVariant & value);
    Q_INVOKABLE int valueInt(const QString &key, int defaultValue = 0) const;
    Q_INVOKABLE QString valueString(const QString& key, const QString& defaultValue = QString()) const;
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE bool contains(const QString &key) const;
    Q_INVOKABLE void remove(const QString& key);
    Q_INVOKABLE void sync();

signals:

public slots:
private:
    QSettings settings_;
};

namespace settingsPublic {

} // namespace

#endif // SETTINGS_H

