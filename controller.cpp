#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{

}

bool Controller::setNewUser(QString info)
{
    //    if(!m_settings.contains(info)){
    m_settings.setValue(info, info);
    return true;
    //    } else {
    //        return false;
    //    }
}

bool Controller::isThereUser(QString user)
{
    return m_settings.contains(user);
}

bool Controller::firstTimeApp()
{
    //returns if it's first time that the app is open
//    m_settings.
    return false;
}
