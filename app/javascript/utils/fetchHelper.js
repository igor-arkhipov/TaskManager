import axios from 'axios';
import qs from 'qs';

import { camelize, decamelize } from './keysConverter';

function authenticityToken() {
  const token = document.querySelector('meta[name="csrf-token"]');
  return token ? token.content : null;
}

function headers() {
  return {
    Accept: '*/*',
    'Content-Type': 'application/json',
    'X-CSRF-Token': authenticityToken(),
    'X-Requested-With': 'XMLHttpRequest',
  };
}

axios.create({
  paramsSerializer: {
    encode: qs.parse,
    serialize: qs.stringify,
  },
});

axios.defaults.headers.get = headers();
axios.defaults.headers.post = headers();
axios.defaults.headers.put = headers();
axios.defaults.headers.delete = headers();
axios.interceptors.response.use(null, (error) => {
  if (error.response.status === 422) {
    const {
      response: { data: errors },
    } = error;
    return Promise.reject(camelize(errors.errors));
  }

  if (error.response.status === 500) {
    return Promise.reject(new Error('Something went wrong, please retry again'));
  }

  return Promise.reject(error);
});

export default {
  get(url, params = {}) {
    return axios.get(url, { params: decamelize(params) }).then(camelize);
  },

  post(url, json) {
    const task = decamelize(json);

    return axios.post(url, task).then(camelize);
  },

  put(url, json) {
    const task = decamelize(json);

    return axios.put(url, task).then(camelize);
  },

  delete(url) {
    return axios.delete(url).then(camelize);
  },
};
