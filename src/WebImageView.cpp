
#include "WebImageView.hpp"
#include <bb/cascades/Image>

QNetworkAccessManager * WebImageView::mNetManager = new QNetworkAccessManager;
QNetworkDiskCache *WebImageView::diskCache = new QNetworkDiskCache;

WebImageView::WebImageView() {
	diskCache->setCacheDirectory("data/cache");
	diskCache->setMaximumCacheSize(1024 * 1024 * 30); //30 Mb
	mNetManager->setCache(diskCache);
	setScalingMethod(ScalingMethod::AspectFit);
	defaultImageUrl="";
}

const QUrl& WebImageView::url() const {
	return mUrl;
}

void WebImageView::setUrl(const QUrl url) {
	if(url != mUrl){
		resetImage();
		mUrl = url;
		QIODevice *temp = diskCache->data(url);
		if(temp){
			setImage(Image(temp->readAll()));
			mLoading = 1;
			emit loadingChanged();
		} else{
			mLoading = 0.01;
			emit loadingChanged();
			if(defaultImageUrl!=QUrl(""))
				setImage(Image(defaultImageUrl));
			urls.push_back(url);
			replies.push_back(mNetManager->get(QNetworkRequest(url)));
			connect(replies.back(),SIGNAL(finished()), this, SLOT(imageLoaded()));
			connect(replies.back(),SIGNAL(downloadProgress ( qint64 , qint64  )), this, SLOT(downloadProgressed(qint64,qint64)));
		}
		emit urlChanged();
	}
}

double WebImageView::loading() const {
	return mLoading;
}

void WebImageView::setLoading(const float loading){
	mLoading = loading;
}

void WebImageView::imageLoaded() {
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());
	if (reply->error() == QNetworkReply::NoError) {
		QVariant repliestatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
		int i=replies.indexOf(reply);
		// HANDLES REDIRECTIONS
		if (repliestatus == 301 || repliestatus == 302)
		{
			QString redirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString();
			replies[i]=mNetManager->get(QNetworkRequest(redirectUrl));
			connect(replies[i],SIGNAL(finished()), this, SLOT(imageLoaded()));
			connect(replies[i],SIGNAL(downloadProgress ( qint64 , qint64  )), this, SLOT(downloadProgressed(qint64,qint64)));
		} else {
			if(urls.at(i)==mUrl)
				setImage(Image(reply->readAll()));
			urls.removeAt(i);
			replies.removeAt(i);
		}
	}
	mLoading = 1;
	emit loadingChanged();
	reply->deleteLater();
}

void WebImageView::downloadProgressed(qint64 bytes,qint64 total) {
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());
	if(reply==replies.back()){
		mLoading =  double(bytes)/double(total);
		emit loadingChanged();
	}
}

const QUrl& WebImageView::defaultImage() const{
	return defaultImageUrl;
}

void WebImageView::setDefaultImage(const QUrl url){
	defaultImageUrl=url;
	if(defaultImageUrl!=QUrl(""))
		setImage(Image(defaultImageUrl));
	emit defaultImageChanged();
}

