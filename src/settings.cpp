#include "settings.h"

Settings::Settings(QObject *parent) :
    QObject(parent)
{
}

void Settings::setValue(const QString &key, const QVariant &value) {
    settings_.setIniCodec( "UTF-8" );
    settings_.setValue(key, value);
}
int Settings::valueInt(const QString& key, int defaultValue) const {
    return value(key, defaultValue).toInt();
}
QString Settings::valueString(const QString& key, const QString& defaultValue) const {
    return value(key, defaultValue).toString();
}
QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return settings_.value(key, defaultValue);
}
bool Settings::contains(const QString &key) const {
    return settings_.contains(key);
}
void Settings::remove(const QString& key) {
    settings_.setIniCodec( "UTF-8" );
    return settings_.remove(key);
}
void Settings::sync() {
    return settings_.sync();
}
