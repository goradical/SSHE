package io.vicp.goradical.sshe.dao;

import io.vicp.goradical.sshe.model.User;

import java.io.Serializable;

public interface UserDao {
	Serializable save(User user);
}
