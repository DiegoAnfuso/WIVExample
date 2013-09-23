
#ifndef WEBIMAGEVIEW_HPP_
#define WEBIMAGEVIEW_HPP_

#include <bb/cascades/ImageView>
#include <qt4/QtNetwork/QNetworkAccessManager>
#include <qt4/QtCore/qurl.h>
#include <qt4/QtDeclarative/qdeclarativedebug.h>
#include <qt4/QtCore/qobject.h>
#include <qt/qnetworkdiskcache.h>

using namespace bb::cascades;

class WebImageView: public bb::cascades::ImageView {
	Q_OBJECT
	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (float loading READ loading WRITE setLoading NOTIFY loadingChanged)
	Q_PROPERTY (QUrl defaultImage READ defaultImage WRITE setDefaultImage NOTIFY defaultImageChanged)
public:
	WebImageView();
	const QUrl& url() const;
	const QUrl& defaultImage() const;
	double loading() const;

public slots:
	void setUrl(const QUrl url);
	void setDefaultImage(const QUrl url);
	void setLoading(const float loading);
private slots:
	void imageLoaded();
	void downloadProgressed(qint64,qint64);

signals:
	void urlChanged();
	void defaultImageChanged();
	void loadingChanged();


private:
	static QNetworkAccessManager * mNetManager;
	static QNetworkDiskCache *diskCache ;
	QUrl mUrl;
	QList<QUrl> urls;
	QList<QNetworkReply* > replies;
	QUrl defaultImageUrl;
	float mLoading;
};

Q_DECLARE_METATYPE(WebImageView *);

#endif
